# This script blocks outbound calls made from jabber while allowing calls from Finesse client.

Go to DeviceSettings > Sip Normalization Script > Click Add New
Table 91: SIP Normalization
Parameter	Value
Name	Jabber_outbound_block_sn
Description	
Content	<paste content of script>
Script Execution Error Recovery Action	<Message Rollback Only>
System Resource Error Recovery Action	<Disable Script>
Memory Threshold	50
Lua Instruction Threshold	1000

Apply the Normalization Script to Sip profile and associate it to phone.

