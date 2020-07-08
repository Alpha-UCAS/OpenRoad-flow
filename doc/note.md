# note

https://theopenroadproject.org/

https://openroad.readthedocs.io/en/latest/index.html

https://github.com/The-OpenROAD-Project-Attic

https://gitter.im/The-OpenROAD-Project/community

这个community的一些有用的信息：since Aug 10 2019 02:10

https://flow.theopenroadproject.org/ 一个云平台

you are more than welcome to try out OpenROAD. We recommend using the alpha release located here: https://github.com/The-OpenROAD-Project/alpha-release. We are currently working towards a new release of the tools of the tools in January. This release is available here, but is not yet stable: https://github.com/The-OpenROAD-Project/OpenROAD

I have a question. I'd like to report my design's area as NAND-gate equivalent, so I need to get the exact area for NAND2 gates the library. Which command in the flow can I use to get that value?

The DB interface is not exactly clean-facing towards the end-user right now. Here is an example script that can get the cell area based on the name:

```
read_lef  platforms/nangate45/lef/NangateOpenCellLibrary.macro.mod.lef
set cell_name NAND2_X1
set lib_name [[ord::get_db] getLibs]
set cell_master [$lib_name findMaster $cell_name]
set height [$cell_master getHeight]
set width [$cell_master getWidth]
set dbu [$lib_name getDbUnitsPerMicron]
set area [expr 1.0 * $height * $width / $dbu / $dbu]
puts "Cell $cell_name area: $area um^2"
```

Alternatively you can just look up the cell in your LEF file and find the SIZE property, e.g.

```
MACRO NAND2_X1
  CLASS CORE ;
  ORIGIN 0 0 ;
  FOREIGN NAND2_X1 0 0 ;
  SIZE 0.57 BY 1.4 ;
```

OpenROAD is a modular tool that uses open-source formats for design exchange (lib, v, LEF, DEF, SDC, SPEF, etc.). If you want to replace a tool with one that offers legal output in those formats, then you are more than welcome to.

Just to be sure that there is no misunderstanding, GHDL is also free and open-source, and provide a yosys module which allows you to read a VHDL file using (from within yosys) : `ghdl your_top` (By that, I mean that there is not much work to do to add the support). You don't have to replace anything and can (probably) mix vhdl and verilog using this.

We are currently focused on stability and correctness of OpenROAD for the next several months, which includes better CI, automating manual steps, and reducing errors and DRVs down to 0 on our benchmark designs. We have a tapeout in an advanced node coming up as part of our funding contract that we are required to meet. Because of this, all of our development resources are focused on these topics.

That being said, I am glad that you are able to get a VHDL flow running with little effort and OpenROAD works for your purposes. Note that we are open to pull requests!

`^` and `v` indicate whether the transition at the pin is a rising edge or a falling edge. I took a quick peek through the OpenSTA documentation and I don't think there is anything specific on the format of the timing reports, but this is fairly standard syntax across different static timing engines.

you should be using the `alpha2` branch, not the `master` branch. The OpenROAD-flow build_openroad.sh script will check this branch out automatically.

**Had to edit OpenROAD-flow/tools/yosys/abc/src/map/scl/sclUtil.c, include tcl.h -> include tcl/tcl.h. Also in yosys makefile ABCREV should be set to 'default'.**

No, report_checks should take under a minute to run on 400k cell designs.

report_checks command
有这个命令吗？

一些人提出的疑似bug的问题：
https://github.com/The-OpenROAD-Project/OpenROAD-flow/issues/65

OpenSTA will check as many constraints as you provide it. You may want to check out the 
If you don't have a constraint for a given path, then OpenSTA will run but it just won't check that path by default. I think you can use report_checks -unconstrained to do so.

I am just getting started with OpenROAD. Amazing job developers!
I have a few questions:
1) What is the tradeoff when choosing the gate sizer TritonSizer vs Resizer?
2) Looking at the ABC script, there seems to be some sizing and buffer insertion in the techmapping stage. Is this a rough sizing, buffering and the TritonSizer/Resizer responsible for more fine-tuned sizing, buffering with placement information?
3) What buffer insertion algorithm is used in TritonSizer/Resizer for timing optimization? Is gate-duplication also used for optimization?

here is the answers:
1) TritonSizer to my knowledge is deprecated. Use resizer.
2) To be honest, most of our developers have been focused on the place and route aspects of the flow. We've been playing around with different ABC scripts recently but we haven't come to statistically significant conclusions yet. Our current aim is to get Yosys to provide a netlist with minimized area and cell count, and then let resizer handle gate resizing and buffering once placement and parasitics information is available. So to answer your question, yes - Yosys does rough buffering and then resizer does fine tuning.
3) Not sure what the buffering algorithm is off the top of my head. I know that there is a gate-cloning optimization pass in the openphysyn openroad tool, but it isn't incorporated into the default OpenROAD-flow yet.

Q: I have got the flow up and running with the provided designs and platform. I was wondering if there are any tips on how I can go about creating my own platform. For example, I want to create a platform for the ASAP7 based NCTU cell library that comes with the RDF-2019: https://github.com/ieee-ceda-datc/RDF-2019/tree/master/techlibs/NCTUcell_lib. From those three .lef files and one .lib file how should I go about creating all the files like in the nangate45 example platform provided? Are all the files even needed? Apologies if my questions are very uninformed!

A: We attempted packaging ASAP7 with OpenROAD-flow last year but there are several structural problems with the kit that make it a bit impractical to use with OpenROAD, as well as other EDA tools. I don't remember the specific details on why. I believe our team is in discussions with ASU about a new release for ASAP7 that will improve compatibility. I can't guarantee any expectations or timeline on this.

A: In general, for creating a new kit, the best advice I can offer is to replicate the parameters for the nangate45 kit as best as possible. You may need to look at the TritonCTS docs about creating characterization files (although automatic characterization is in the works).
We plan on making more documentation for this sort of thing in 2H 2020.

## book

http://gen.lib.rus.ec/search.php?&req=The+Art+of+Electronics+&phrase=1&view=simple&column=def&sort=year&sortmode=DESC

http://gen.lib.rus.ec/search.php?req=Design+of+CMOS+Phase-Locked+Loops%3A+From+Circuit+Level+to+Architecture+Level+&open=0&res=25&view=simple&phrase=1&column=def


https://www.amazon.com/Paul-Horowitz/e/B000APV6LW/ref=pd_sbs_14_bl_3/130-8617459-4786745?_encoding=UTF8&pd_rd_i=0521809266&pd_rd_r=853a46e9-f2ce-42ad-964f-1f51fefcc476&pd_rd_w=nBplq&pd_rd_wg=XdAat&pf_rd_p=12b8d3e2-e203-4b23-a8bc-68a7d2806477&pf_rd_r=ZR2NH88AZ6ZVM7SRSBPR&refRID=ZR2NH88AZ6ZVM7SRSBPR

## course

EE219B Logic Synthesis for Hardware Systems

https://inst.eecs.berkeley.edu/~ee219b/archives.html

https://people.eecs.berkeley.edu/~brayton/courses/219b/


## project

http://www.clifford.at/yosys/

https://scholar.google.com/citations?user=FD-dYHgAAAAJ&hl=en&oi=sra

http://vlsicad.eecs.umich.edu/BK/parquet/#DOWN

TritonCTS, https://github.com/abk-openroad/TritonCTS

OpenSTA, https://github.com/abk-openroad/OpenSTA

https://vlsicad.ucsd.edu/GSRC/metrics/

http://scale.engin.brown.edu/woset/

## researcher

https://vlsicad.ucsd.edu/~abk/

https://scholar.google.com/citations?user=zCO_h3cAAAAJ&hl=en&oi=sra

https://vlsicad.ucsd.edu/

## Build

The OpenROAD build requires the following packages:

  * cmake 3.9 //cmake自己手段安装，版本要求更新了
  * gcc or clang
  * bison
  * flex
  * swig 3.0 //这是docker一直卡住的地方
  * boost //boost自己手动安转
  * tcl 8.5 // apt-get一下即可，但是需要软链接
  * zlib

编译klayout软件需要用python2.7，并且需要安装ruby，还需要Qt4或者Qt5
source ./setup_local.sh
cd flow
make DESIGN_CONFIG=./designs/nangate45/bian.mk

如果修改mk文件，那么就要make clean_all之后重新make

已经走的都是FPGA的路子，现在来走一走ASIC的路子

chiwen就像一个慢动作回放

软链接一劳永逸

还需要对cache进行综合！！！

## TODO

有没有真实对比过商业eda工具和开源eda工具核心的差距在哪里？

定时的更新工程

时序的问题，其实说明不了太多问题的，要考虑访存方面的时序压力

if这一级，dec这一级都需要预留

16 39 62 85

对cache进行一下EDA流程！

相近代码的结果diff对比，一定要做