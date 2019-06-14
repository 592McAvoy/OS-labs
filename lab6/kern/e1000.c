#include <kern/e1000.h>
#include <kern/pmap.h>
#include <inc/string.h>
#include <inc/error.h>

static volatile struct E1000 *base;

struct tx_desc *tx_descs;
#define N_TXDESC (PGSIZE / sizeof(struct tx_desc))
char tx_bufs[N_TXDESC][TX_PKT_SIZE];


//volatile struct E1000 *e1000;

int
e1000_tx_init()
{
	// Allocate one page for descriptors
	struct PageInfo *pp = page_alloc(ALLOC_ZERO);
	tx_descs = (struct tx_desc *)page2kva(pp);

	// Initialize all descriptors
	memset(tx_bufs, 0, sizeof(tx_bufs));
	for(int i=0;i<N_TXDESC;i++){
		tx_descs[i].addr = PADDR(tx_bufs[i]);
		tx_descs[i].status |= E1000_TX_STATUS_DD;
	}

	// Set hardward registers
	// Look kern/e1000.h to find useful definations
	base->TDBAL = PADDR(tx_descs);
	base->TDBAH = 0;
	base->TDLEN = PGSIZE;
	base->TDH = 0;
	base->TDT = 0;

	base->TCTL |= E1000_TCTL_EN;
	base->TCTL |= E1000_TCTL_PSP;
	base->TCTL |= E1000_TCTL_CT_ETHER;
	base->TCTL |= E1000_TCTL_COLD_FULL_DUPLEX;

	base->TIPG |= E1000_TIPG_DEFAULT;

	return 0;
}

struct rx_desc *rx_descs;
#define N_RXDESC (PGSIZE / sizeof(struct rx_desc))
char rx_bufs[N_RXDESC][RX_PKT_SIZE];

static uint16_t
EEPROM_MAC(uint8_t addr)
{
	base->EERD |= E1000_EERD_START | (addr << 8);
	while(!(base->EERD & E1000_EERD_DONE));
	cprintf("[EEPROM_MAC] read %04x at addr %02x\n", base->EERD >> 16, addr);
	base->EERD &= ~E1000_EERD_DONE;
	return base->EERD >> 16;
}

int
e1000_rx_init()
{
	// Allocate one page for descriptors
	struct PageInfo *pp = page_alloc(ALLOC_ZERO);
	rx_descs = (struct rx_desc *)page2kva(pp);

	// Initialize all descriptors
	// You should allocate some pages as receive buffer
	memset(rx_bufs, 0, sizeof(rx_bufs));
	for(int i=0;i<N_RXDESC;i++){
		rx_descs[i].addr = PADDR(rx_bufs[i]);
	}

	// Set hardward registers
	// Look kern/e1000.h to find useful definations


	//	Challenge!
	uint16_t MAC_LOW = EEPROM_MAC(0x0);
	uint16_t MAC_MID = EEPROM_MAC(0x1);
	uint16_t MAC_HIGH = EEPROM_MAC(0x2);

	E1000_MAC[0] = (MAC_LOW >> 0) & 0xFF;
	E1000_MAC[1] = (MAC_LOW >> 8) & 0xFF;
	E1000_MAC[2] = (MAC_MID >> 0) & 0xFF;
	E1000_MAC[3] = (MAC_MID >> 8) & 0xFF;
	E1000_MAC[4] = (MAC_HIGH >> 0) & 0xFF;
	E1000_MAC[5] = (MAC_HIGH >> 8) & 0xFF;
	

	cprintf("MAC address read from EEPROM: %02x:%02x:%02x:%02x:%02x:%02x\n",
			E1000_MAC[0], E1000_MAC[1],E1000_MAC[2],E1000_MAC[3],E1000_MAC[4],E1000_MAC[5]);

	base->RAH = MAC_HIGH | E1000_RAH_AV;
	base->RAL = (MAC_MID << 16) | MAC_LOW;
	
	cprintf("RAL:RAH %08x:%08x\n", base->RAL, base->RAH);
	// base->RAH = QEMU_MAC_HIGH | E1000_RAH_AV;
	// base->RAL = QEMU_MAC_LOW;
	// cprintf("RAL:RAH %08x:%08x\n", base->RAL, base->RAH);

	base->RDBAL = PADDR(rx_descs);
	base->RDBAH = 0;
	base->RDLEN = PGSIZE;	

	base->RDH = 1;
	base->RDT = 0;

	base->RCTL |= E1000_RCTL_EN;
	//base->RCTL |= E1000_RCTL_BAM;
	base->RCTL |= E1000_RCTL_BSIZE_2048;
	base->RCTL |= E1000_RCTL_SECRC;

	return 0;
}

int
pci_e1000_attach(struct pci_func *pcif)
{
	// Enable PCI function
	// Map MMIO region and save the address in 'base;
	pci_func_enable(pcif);

	base = (struct E1000 *)mmio_map_region(pcif->reg_base[0], pcif->reg_size[0]);
	cprintf("e1000: status: 0x%08x\n", base->STATUS);

	e1000_tx_init();
	e1000_rx_init();

	return 0;
}

int
e1000_tx(const void *buf, uint32_t len)
{
	// Send 'len' bytes in 'buf' to ethernet
	// Hint: buf is a kernel virtual address
	if(!buf || len > TX_PKT_SIZE)
		return -E_INVAL;
	
	uint32_t tdt = base->TDT;
	if(!(tx_descs[tdt].status & E1000_TX_STATUS_DD))
		return -E_TX_FULL;

	memset(tx_bufs[tdt], 0, TX_PKT_SIZE);
	memmove(tx_bufs[tdt], buf, len);

	tx_descs[tdt].length = len;
	tx_descs[tdt].cmd |= E1000_TX_CMD_RS;
	tx_descs[tdt].cmd |= E1000_TX_CMD_EOP;
	tx_descs[tdt].status &= ~E1000_TX_STATUS_DD;

	base->TDT = (tdt+1) % N_TXDESC;

	return 0;
}

int
e1000_rx(void *buf, uint32_t len)
{
	// Copy one received buffer to buf
	// You could return -E_AGAIN if there is no packet
	// Check whether the buf is large enough to hold
	// the packet
	// Do not forget to reset the decscriptor and
	// give it back to hardware by modifying RDT
	if(!buf)
		return -E_INVAL;
	
	uint32_t rdt = (base->RDT+1) % N_RXDESC;
	if(!(rx_descs[rdt].status & E1000_RX_STATUS_DD))
		return -E_AGAIN;
	
	while(rdt == base->RDH);

	uint32_t data_len = rx_descs[rdt].length;
	assert(len >= data_len);
	memmove(buf, rx_bufs[rdt], data_len);

	rx_descs[rdt].status &= ~E1000_RX_STATUS_DD;
	rx_descs[rdt].status &= ~E1000_RX_STATUS_EOP;

	base->RDT = rdt;

	return data_len;
}
