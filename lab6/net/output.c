#include "ns.h"

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
	binaryname = "ns_output";

	// LAB 6: Your code here:
	// 	- read a packet request (using ipc_recv)
	//	- send the packet to the device driver (using sys_net_send)
	//	do the above things in a loop

	int r;
	while(1){
		if((r = sys_ipc_recv((void*)&nsipcbuf)) < 0)
			panic("[output - sys_ipc_recv] %e", r);
		
		if((thisenv->env_ipc_from != ns_envid) || (thisenv->env_ipc_value != NSREQ_OUTPUT))
			continue;

		while((r = sys_net_send(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len))<0){
			if(r != -E_TX_FULL)
				panic("[output - sys_net_send] %e", r);
		}
	}
}
