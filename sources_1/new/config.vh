`ifndef CONFIG_VH
`define CONFIG_VH

// ------ ROM ------ //
`define ROM_AMPLITUDE       1000            // Amplituda sygna³u w ROM (mV)
`define ROM_AMPLITUDE_BIT   12              // Iloœæ bitów potrzebna na zapis amplitudy
`define ROM_PHASE_MAX_VAL   14'd10000       // Iloœæ próbek sygna³u
`define ROM_PHASE_BIT       14              // Iloœæ bitów potrzebna na zapis fazy

// ------ DAC ------ //
//`define DAC_MAX_V           3300            // Maksymalne napiêcie przetwornika DAC
`define DAC_MAX_V_BIT       12              // Iloœæ bitów potrzebna na zapis maksymalnego napiêcia

// ------ DDS ------ //
`define DDS_CLOCK_PERIOD    6               // Czas co który zmiania siê faza (us)

`endif
