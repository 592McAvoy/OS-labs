#include "ns.h"

extern union Nsipc nsipcbuf;

void
input(envid_t ns_envid)
{
	binaryname = "ns_input";

	// LAB 6: Your code here:
	// 	- read a packet from the device driver
	//	- send it to the network server (using ipc_send with NSREQ_INPUT as value)
	//	do the above things in a loop
	// Hint: When you IPC a page to the network server, it will be
	// reading from it for a while, so don't immediately receive
	// another packet in to the same physical page.
	int r, len;
	char buf[2048];

	while(1){
		while((r = sys_net_recv(buf, 2048)) < 0){
			if(r != -E_AGAIN)
				panic("[input - sys_net_recv]:%e",r);
		}

		len = r;

		if((r = sys_page_alloc(thisenv->env_id, &nsipcbuf, PTE_P|PTE_W|PTE_U)) < 0)
			panic("[input - sys_page_alloc]:%e");

		nsipcbuf.pkt.jp_len = len;
		memmove(nsipcbuf.pkt.jp_data, buf, len);

		if((r = sys_ipc_try_send(ns_envid, NSREQ_INPUT, &nsipcbuf, PTE_P|PTE_W|PTE_U)) < 0)
			panic("[input - sys_ipc_try_send]:%e");
	}
}
