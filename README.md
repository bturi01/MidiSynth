# MidiSynth

This project is a MIDI Synthesizer designed for a Spartan 3 FPGA.

The structure of the audio synthesis is:

MIDI -> | FPGA | -> UART -> MIDI Decode -> Polyphony (TODO) -> NCO and other DSP stuff -> I2S -> | FPGA | -> ADC
