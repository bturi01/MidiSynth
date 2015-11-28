# MidiSynth

This project is a MIDI Synthesizer designed for a Spartan 3 FPGA.

The structure of the audio synthesis is:

MIDI -> | FPGA | -> UART -> MIDI Decode -> Polyphony (TODO) -> NCO and other DSP stuff -> I2S -> | FPGA | -> ADC

<h3>MIDI</h3>
A variety of sources can provide MIDI data.  
Used:  
  -Raspberry Pi GPIO Pins connected directly to FPGA Expansion Connectors  
  -MIDI Keyboard Controller:  
      Keyboard -> MIDI Cable -> USB -> | FPGA | -> USB -> PS2 | FPGA |
