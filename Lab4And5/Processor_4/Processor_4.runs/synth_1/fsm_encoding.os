
 add_fsm_encoding \
       {MasterInterfaceProc.state} \
       { }  \
       {{000 000} {001 001} {010 010} {011 011} {100 100} }

 add_fsm_encoding \
       {SlaveInterfaceMemory.state} \
       { }  \
       {{0000 0000} {0001 0001} {0010 0010} {0011 0011} {0100 0100} {0101 0101} {0110 0110} {0111 0111} {1000 1000} }

 add_fsm_encoding \
       {SlaveInterfaceLed.state} \
       { }  \
       {{0000 000} {0001 001} {0101 010} {0110 011} {0111 100} {1000 101} }

 add_fsm_encoding \
       {SlaveInterfaceSSD.state} \
       { }  \
       {{0000 000} {0101 001} {0110 010} {0111 011} {1000 100} }
