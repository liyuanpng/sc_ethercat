// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

#include <print.h>
#include <xs1.h>
#include <frame.h>
#include <handler.h>


clock clkR = XS1_CLKBLK_2;
clock clkT = XS1_CLKBLK_3;
port rxClk = XS1_PORT_1A;
port txClk = XS1_PORT_1C;
port validRx = XS1_PORT_1B;
port validTx = XS1_PORT_1D;
buffered in port:8 dataRx = XS1_PORT_4A;
buffered out port:8 dataTx = XS1_PORT_4B;

int main() {
    streaming chan rx2proto, proto2tx;
                                               
    configure_clock_src(clkR, rxClk);
    configure_in_port(validRx, clkR);
    configure_in_port_strobed_slave(dataRx, validRx, clkR);
    configure_clock_src(clkT, txClk);
    configure_in_port(validRx, clkT);
    configure_out_port_strobed_master(dataTx, validTx, clkT, 0);
    start_clock(clkR);
    start_clock(clkT);

    par {
        rxProcess(validRx, dataRx, rx2proto);
        txProcess(dataTx, proto2tx);
        frameProcess(rx2proto, proto2tx);
    }
    return 0;
}