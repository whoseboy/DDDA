# DDDA (Data Driven Dimensional Analysis)

DDDA can extract the uniqueness and relative importance features in dimensionless number from one or more sets of experiment data. This package is basic on buckinhum pi theory but upgraded. 

## In this README :point_down:

- [Features](#features)
- [Usage](#usage)
  - [Initial setup](#initial-setup)
  - [Creating releases](#creating-releases)
- [Projects using this template](#projects-using-this-template)
- [FAQ](#faq)
- [Contributing](#contributing)

## Features

🚀 Fast (and light) All algorithms work within optimised data structure:
  - 60,000 float paremeters consume 2GB memeroy and finish in 20 seconds(3.2GHz 6 cores x86 platform).
  - No GPU needed.
  - low storage space occupacion.

🔐 Robust
  - All way has one converge path

📊 Great visualisation
  - All the key parameter were illustrate by chart

🏄 Easy to use


## Usage

### Initial setup

1. [Download package in local]
  
    Github
    
    Shell: (https) & (ssh)
    ```
    git clone https://github.com/whoseboy/DDDA.git
    git clone git@github.com:whoseboy/DDDA.git
    
    ```

2. Create a Python 3.8 or newer virtual environment.

    *Use Anaconda:*
    ```
    conda create -n my-package python=3.8
    conda activate my-package
    ```

    *Then install compulsery package:*

    ```
    conda install numpy pandas scipy copy math numba sklearn pylab operator random
    ```
    *Opetional package:*

    ```
    conda install matplotlib seaborn time
    ```


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

## Ongoing
Pressure test

## Version update
**v0.0.1** The package was illustrate in 3d case, but it can succesefuly work in n-D case, also we simplified the time and memory comsumption.
**v0.0.0** Prove the methodology in 2D case
