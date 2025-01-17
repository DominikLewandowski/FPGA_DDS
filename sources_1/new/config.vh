`ifndef CONFIG_VH
`define CONFIG_VH

// ------ ROM ------ //
`define ROM_AMPLITUDE       1000            // Signal amplitude in ROM (mV)
`define ROM_AMPLITUDE_BIT   12              // Signal amplitude in ROM - size (bits)
`define ROM_PHASE_MAX_VAL   15'd16667       // Number of samples in ROM
`define ROM_PHASE_BIT       15              // Number of samples in ROM - size (bits)

// ------ DAC ------ //
`define DAC_MAX_V           3300            // Maxixmum output voltage of the DAC
`define DAC_MAX_V_BIT       12              // Maxixmum output voltage of the DAC - size (bits)

// ------ DDS ------ //
`define DDS_CLOCK_PERIOD    6               // Clock period of phase value change (us) - ONLY EVEN VALUES!

`endif
