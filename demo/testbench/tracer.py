#!/usr/bin/env python

import sys
import re

INST_RE = re.compile(r"ExeInst: DASM\(([0-9a-f]+)\)")
regfiledict = {'01': 'ra', '02': 'sp', '03': 'gp', '04': 'tp', '05': 't0', '06': 't1', '07': 't2', '08': 's0', '09': 's1',
               '0a': 'a0', '0b': 'a1', '0c': 'a2', '0d': 'a3', '0e': 'a4', '0f': 'a5', '10': 'a6', '11': 'a7', '12': 's2',
               '13': 's3', '14': 's4', '15': 's5', '16': 's6', '17': 's7', '18': 's8', '19': 's9', '1a': 'sa', '1b': 'sb',
               '1c': 't3', '1d': 't4', '1e': 't5', '1f': 't6', '00': '00'}
class Tracer:
    # Initialize your new counters to 0 here
    def __init__(self):
        self.inst_count = 0
        self.nop_count = 0
        self.bubble_count = 0
        self.misc_count = 0
        self.br_count = 0
        self.ld_count = 0
        self.st_count = 0
        self.jal_count = 0
        self.jalr_count = 0
        self.arith_count = 0
        self.cycles = 0

    # Increment your counters as appropriate here
    def tick(self, inst):
        opcode = inst & 0x7f
        opc_hi = (opcode >> 5) & 0x3
        opc_lo = (opcode >> 2) & 0x7

        if inst != 0x4033:
            self.inst_count += 1

        if inst == 0x13:
            self.nop_count += 1
        elif inst == 0x4033:
            self.bubble_count += 1
        elif opcode == 0x6f:
            self.jal_count += 1
        elif opcode == 0x67:
            self.jalr_count += 1
        elif opcode == 0x63:
            self.br_count += 1
        elif opcode == 0x03:
            self.ld_count += 1
        elif opcode == 0x23:
            self.st_count += 1
        elif opc_lo == 0x4 or opcode == 0x37:
            self.arith_count += 1
        else:
            self.misc_count += 1

        self.cycles += 1

    # Print your new counts here
    def print_results(self):
        print("#----------Stats--------------")
        print("#")
        print("#   CPI    : {:2.2f}".format(float(self.cycles) / self.inst_count))
        print("#   IPC    : {:2.2f}".format(float(self.inst_count) / self.cycles))
        print("#   cycles : {}".format(self.cycles))
        print("#")
        print("#   Bubbles      : {:2.3f} %".format(float(self.bubble_count) / self.cycles * 100))

        print("#   Nop instr    : {:2.3f} %".format(float(self.nop_count) / self.inst_count * 100))
        print("#   Arith instr  : {:2.3f} %".format(float(self.arith_count) / self.inst_count * 100))
        print("#   Ld instr     : {:2.3f} %".format(float(self.ld_count) / self.inst_count * 100))
        print("#   St instr     : {:2.3f} %".format(float(self.st_count) / self.inst_count * 100))
        print("#   Jal instr    : {:2.3f} %".format(float(self.jal_count) / self.inst_count * 100))
        print("#   Jalr instr   : {:2.3f} %".format(float(self.jalr_count) / self.inst_count * 100))
        print("#   branch instr : {:2.3f} %".format(float(self.br_count) / self.inst_count * 100))
        print("#   misc instr   : {:2.3f} %".format(float(self.misc_count) / self.inst_count * 100))

def main():
    tracer = Tracer()

    for line in sys.stdin:
        line = line.strip()
        m = INST_RE.search(line)
        if m:
            inst = int(m.group(1), 16)
            tracer.tick(inst)
        if line == '':
            print('\n')
            continue
        words = line.strip().split()
        if words[0] == 'Core:' and words[3] == 'WB[':
            print(line[0:28]+regfiledict[line[28:30]]+line[30:])
        # elif words[0] == 'Core:':
        #     print(line[0:55] + regfiledict[line[55:57]] + line[57:68] + regfiledict[line[68:70]] +
        #           line[70:77] + regfiledict[line[77:79]] + line[79:])
        else:
            print(line)
            # if words[0] == 'store:' and words[1] == 'head':
            #     print
            # if words[0] == 'instQueue_0':
            #     print

    tracer.print_results()

if __name__ == "__main__":
    main()
