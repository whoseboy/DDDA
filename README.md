# DDDA (Data Driven Dimensional Analysis)

DDDA can extract the uniqueness and relative importance features in dimensionless number from one or more sets of experiment data. This package is basic on buckinhum pi theory but upgraded. 

## In this package :point_down:

- [Features](#features)
- [Usage](#usage)
  - [Initial setup](#initial-setup)
  - [Using DDDA](#using-ddda)
- [Proved case using this package](#proved-case-using-this-package)
- [About DDDA](#about-ddda)
- [Example](#example)
  - [Tubeflow 2D](#tubeflow)
  - [Self defined dataset 3D](#self-defined-dataset)
- [FAQ](#faq)
- [Ongoing](#ongoing)
- [Version update](#version-update)
- [Contributing](#contributing)
- [Reference](#reference)



## Features

🔐 Robust 
  - 强噪声抑制 —— 在数据预处理截断我们开发并在全局上使用了高阶的自适应收敛算法，至少在2阶精度上使每一数据点做到了最佳收敛。

🏄 Researcher friendly
  - 可以根据使用者所处环境内的噪声情况对结果的不确定性进行定量化。
  - 我们尽最大程度减少了自定义参数。

📊 Good visualisation
  - 所有的数据都可以方便的以图表方式呈现。
 
🚀 Fast (and light) All algorithms work within optimised data structure:
  - 针对高维度大数据量计算进行了数据结构优化，随着数据维度(k)增加，主要代码的时间复杂度由O(n^k)降低为O(kN^(1-1/k)).
  
## Usage

### Initial setup

1. Download package to local
  
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

### Using DDDA


## Proved case using this package

Here is an real case list of some datasets that has been proved in this package:

- [2D Tubeflow](https://github.com/whoseboy/DDDA/tree/main/Examples/TubeFlow%202D)
- [3D Self-defined case](https://github.com/whoseboy/DDDA/tree/main/Examples/Selfdefined%203Dcase)
- [4D ](https://github.com/ExampleCase/???)
- [5D ](https://github.com/ExampleCase/???)

☝️ *Download dataset above and import into package*

## About DDDA

### Work flow
<p align="center">
<img src="https://github.com/whoseboy/DDDA/blob/main/docs/figures/TubeFlow2D/DDDA_FrameFlow.png" >
</p>
This package can evaluate the rest of work automatially if the reasearcher get the data from experiment or simulation. The datasets could aquire from varies source, and of course in varies noise distribution and confidence interval.


### Local convergence algorithm

<img src="https://github.com/whoseboy/DDDA/blob/main/docs/figures/TubeFlow2D/AdaptiveSmooth.png" width="390" height="270"><img src="https://github.com/whoseboy/DDDA/blob/main/docs/figures/TubeFlow2D/ConvergingBenchmark.png" width="390" height="270">


### Weight assign algorithm 
<p align="center">
<img src="https://github.com/whoseboy/DDDA/blob/main/docs/figures/TubeFlow2D/Voronoi.png" width="640" height="340">
</p>

## Example 

### Tubeflow
This case is performed in v0.0.0, which is the initial edition specified in 2D. The dataset come out of real experiment.

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

### Self defined dataset
This case is performed in v0.0.0, which is the initial edition specified in 3D. The dataset generate by self-defined function

## FAQ

#### Why the independent value must in exponential form?
Because...


## Ongoing
v0.0.3 - Universial edition in any dimension by a standalone file, Pressure test in dimension up to 5, Double regression in case of truncation & support domain

## Version update
**v0.0.1** The package was illustrate in 3d case, but it can succesefuly work in n-D case, also we simplified the time and memory comsumption.

**v0.0.0** Prove the methodology in 2D case

## Contributing


## Reference

