# DDDA (Data Driven Dimensional Analysis) v1.4.1

DDDA can extract the uniqueness and relative importance features in dimensionless number from one or more sets of experiment data. This package is basic on buckinhum pi theory but upgraded. 

## 目录 :point_down:

- [特点](#特点)
- [入门指南](#入门指南)
  - [安装DDDA](#安装)
  - [如何使用DDDA代码包](#如何使用代码包)
- [DDDA的示例](#示例)
- [关于本程序包](#关于本程序包)
  - [工作流程图](#工作流程图)
  - [部分算法解释](#部分算法解释)
- [流程概览](#流程概览)
- [FAQ](#faq)
- [Ongoing](#ongoing)
- [Version update](#version-update)
- [Contributing](#contributing)
- [Reference](#reference)



## 特点

🔐 Robust 
  - 强噪声抑制 —— 在数据预处理截断我们开发并在全局上使用了高阶的自适应收敛算法，至少在2阶精度上使每一数据点做到了最佳收敛。

🏄 Researcher friendly
  - 可以根据使用者所处环境内的噪声情况对结果的不确定性进行定量化。
  - 我们尽最大程度减少了自定义参数。

📊 Good visualisation
  - 所有的数据都可以方便的以图表方式呈现。
 
🚀 Fast (and light) All algorithms work within optimised data structure:
  - 针对高维度大数据量计算进行了数据结构优化，随着数据维度(k)增加，主要代码的时间复杂度由O(n^k)降低为O(kN^(1-1/k)).
  
## 入门指南

### 安装

1. 下载代码包至本地
  
    Github
    
    Shell: (https) & (ssh)
    ```
    git clone https://github.com/whoseboy/DDDA.git
    git clone git@github.com:whoseboy/DDDA.git
    
    ```

2. 创建 Python 3.8 或以上更新环境.

    *使用 Anaconda:*
    ```
    conda create -n my-package python=3.8
    conda activate my-package
    ```

    *需要安装的代码包:*

    ```
    conda install numpy pandas scipy copy math numba sklearn pylab operator random
    ```
    *可以选装的代码包 —— 用于可视化和计时:*

    ```
    conda install matplotlib seaborn time
    ```

### 如何使用代码包


## 示例

我们在jupyter notebook中提供了简洁易读的测试算例:

- [2D Tubeflow](https://github.com/whoseboy/DDDA/tree/main/Examples/TubeFlow%202D)
- [3D Self-defined case](https://github.com/whoseboy/DDDA/tree/main/Examples/Selfdefined%203Dcase)

☝️ *上述算例的详细信息可以看链接内文件夹中的readme文档*

## 关于本程序包

### 工作流程图
<p align="center">
<img src="https://github.com/whoseboy/DDDA/blob/main/docs/figures/TubeFlow2D/DDDA_FrameFlow.png" >
</p>
This package can evaluate the rest of work automatially if the reasearcher get the data from experiment or simulation. The datasets could aquire from varies source, and of course in varies noise distribution and confidence interval.


### 部分算法解释

#### 自适应收敛光滑

<img src="https://github.com/whoseboy/DDDA/blob/main/docs/figures/Converge2.png" >
<img src="https://github.com/whoseboy/DDDA/blob/main/docs/figures/1n2Converge.png" >
<img src="https://github.com/whoseboy/DDDA/blob/main/docs/figures/DataDense.png" >

<p align="center">
<img src="https://github.com/whoseboy/DDDA/blob/main/docs/figures/TubeFlow2D/AdaptiveSmooth.png" >
</p>

### 基于位置噪声的权重分配 
<p align="center">
<img src="https://github.com/whoseboy/DDDA/blob/main/docs/figures/TubeFlow2D/Voronoi.png">
</p>

## 流程概览 
我们以2维与3维算例为基础，按流程图的顺序向您展示我们代码中每一步骤的实现方法和巧思。
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


## FAQ

### 输入的数据结构


## 正在开发中
v2.0.0 - 对噪声的传播进行定量化。

## 重要版本更新

**v1.4.0** 确定了参数之间的相关性，减少了用户自定义参数，提高易用性

**v1.3.0** 重写了聚类算法，提升了聚类精度。提升了数据可视化程度

**v1.2.0** 更新收敛算法，从单一的0阶距提升到了高阶距

**v1.1.0** 数据结构优化

**v1.0.0** 改写MATLAB代码到Python

**v0.4.2** 完整的MATLAB下的三维代码实现

**v0.3.1** 截止到分区的MATLAB下的三维代码实现

**v0.2.0** 截止到分区的MATLAB下的二维代码实现


