# DDDA (Data Driven Dimensional Analysis)
DDDA can solve the dynamics system automatically in process between data acquisition to formula fitting. This package aiming for secure researcher from tedious work
and take them back to innovation.

## How to use?
Package requirement: numpy, scipy, pandas, matplotlib/seaborn, copy, mpl_toolkits, pycddlib 

(The well packed code is coming soon.)

**v0.0.0:**  2D Tube flow example
1. Download

&ensp; (https) git clone https://github.com/whoseboy/DDDA.git

&ensp; (ssh) git clone git@github.com:whoseboy/DDDA.git

2. Run tube flow example

&ensp; In folder v0.0.0, open 2D_TubeFlow.ipynb

&ensp; run

## What inside?
Beside of the work flow in this composited package, we developed two amazied algorithm(And more in house:) ).

### Work flow
<p align="center">
<img src="https://github.com/whoseboy/DDDA/blob/main/docs/figures/TubeFlow2D/DDDA_FrameFlow.png" width="890" height="320">
</p>
This package can evaluate the rest of work automatially if the reasearcher get the data from experiment or simulation. The datasets could aquire from varies source, and of course in varies noise distribution and confidence interval.


### Local convergence algorithm

<img src="https://github.com/whoseboy/DDDA/blob/main/docs/figures/TubeFlow2D/AdaptiveSmooth.png" width="390" height="270"><img src="https://github.com/whoseboy/DDDA/blob/main/docs/figures/TubeFlow2D/ConvergingBenchmark.png" width="390" height="270">


### Weight assign algorithm 
<p align="center">
<img src="https://github.com/whoseboy/DDDA/blob/main/docs/figures/TubeFlow2D/Voronoi.png" width="640" height="340">
</p>

## Example (2D TubeFlow)
<p align="center">
<img src="https://github.com/whoseboy/DDDA/blob/main/docs/figures/TubeFlow2D/TubeData.png" width="640" height="340">
</p>

<p align="center">
<img src="https://github.com/whoseboy/DDDA/blob/main/docs/figures/TubeFlow2D/TubePosition.png" width="640" height="340">
</p>

<p align="center">
<img src="https://github.com/whoseboy/DDDA/blob/main/docs/figures/TubeFlow2D/SmoothInter.png" width="640" height="340">
</p>

<p align="center">
<img src="https://github.com/whoseboy/DDDA/blob/main/docs/figures/TubeFlow2D/PartialD.png" width="640" height="340">
</p>

<p align="center">
<img src="https://github.com/whoseboy/DDDA/blob/main/docs/figures/TubeFlow2D/EigenVector.png" width="640" height="340">
</p>

<p align="center">
<img src="https://github.com/whoseboy/DDDA/blob/main/docs/figures/TubeFlow2D/ClusterTubeFlow.png" width="640" height="340">
</p>

## Version update
**v0.0.0** 
