`ifndef CONFIG_VH
`define CONFIG_VH

// ------ ROM ------ //
`define ROM_AMPLITUDE       1000            // Amplituda sygna�u w ROM (mV)
`define ROM_AMPLITUDE_BIT   12              // Ilo�� bit�w potrzebna na zapis amplitudy
`define ROM_PHASE_MAX_VAL   14'd10000       // Ilo�� pr�bek sygna�u
`define ROM_PHASE_BIT       14              // Ilo�� bit�w potrzebna na zapis fazy

// ------ DAC ------ //
//`define DAC_MAX_V           3300            // Maksymalne napi�cie przetwornika DAC
`define DAC_MAX_V_BIT       12              // Ilo�� bit�w potrzebna na zapis maksymalnego napi�cia

// ------ DDS ------ //
`define DDS_CLOCK_PERIOD    6               // Czas co kt�ry zmiania si� faza (us)

`endif
