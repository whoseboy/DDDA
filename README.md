# DDDA (Data Driven Dimensional Analysis) v1.6.1
# 数据驱动量纲分析 v1.6.1

DDDA(Data Driven Dimensional Analysis), when applied to a set of real-world data, can extract the unique and dominating dimensionless number from the data based on Buckingham Pi Theorem. It will help human or robot scientists to compress the data and convert the hidden knowledge into a simple and clear empirical law of one or two (novel) combined dimensionless numbers. The whole process is automatic and involves very few artificial parameters.

DDDA-数据驱动量纲分析，是一套**用于从数据中自动提取主控（新）无量纲数的开源代码**。代码可以在几乎不需要人工参与的条件下，从高维（多个参数或无量纲数控制）的数据集中，自动找到主导的（组合）无量纲数（供您命名），并按照无量纲数的形式分割整个数据区域，并在每个区域给出最优的经验公式。在常见力学问题中，方法可以将高至9维的数据集压缩为分段的一至二维显式函数表达，从而为人类和机器科学家提供探索规律的基本工具。

## 目录 :point_down:

- [特点](#特点)
- [入门指南](#入门指南)
  - [安装DDDA](#安装)
  - [如何使用DDDA代码包](#如何使用代码包)
- [DDDA的示例](#示例)
- [关于本程序包](#关于本程序包)
  - [工作流程图](#工作流程图)
  - [部分算法解释](#部分算法解释)
- [DDDA工作流程概览](#流程概览)
- [FAQ](#faq)
- [正在开发中](#ongoing)
- [重要版本更新](#version-update)

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

### 使用选项

1. 直接使用Matlab代码，与论文示例一致，相关代码和示例见(Matlab版本可以作为快速学习之用，当前仅有2D和3D版本)：  
2D case: https://github.com/whoseboy/DDDA/tree/989c8f1f55662becfd0f7311ec50d1b553e48806/Example/Matlab_DDDA%20for%20the%202D%20case%20(pressure%20drops%20in%20pipe%20flows)  
3D case: https://github.com/whoseboy/DDDA/tree/989c8f1f55662becfd0f7311ec50d1b553e48806/Example/Matlab_DDDA%20for%20the%203D%20case

2. 使用JupyterNote Book快速试用并学习DDDA方法(iPython版本可以作为快速学习之用，当前仅有2D和3D版本)：  
2D case:   
https://github.com/whoseboy/DDDA/tree/989c8f1f55662becfd0f7311ec50d1b553e48806/Example/Case_2D  
3D case:   
https://github.com/whoseboy/DDDA/tree/989c8f1f55662becfd0f7311ec50d1b553e48806/Example/Case_3D_1
https://github.com/whoseboy/DDDA/tree/989c8f1f55662becfd0f7311ec50d1b553e48806/Example/Case_3D_2


3. 使用标准Python包，用于高效运行DDDA算法：
https://github.com/whoseboy/DDDA/tree/989c8f1f55662becfd0f7311ec50d1b553e48806/DDDA  
可以使用conda和pip两种方式安装，具体安装方式如下。


### 安装

#### 使用conda

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

#### 使用pip

    *安装辅助包，涉及的包包含在requirments.txt中*
    （修改中）
    
    *安装DDDA：*
    ```
    pip install DDDA
    ```



### 如何使用代码包


## 示例
### 如何使用
这里我们提供了DDDA()函数负责传输数据，参数。DDDARun()函数负责开始运算。

    *三维且默认参数的示例， 其中DataF为数据，DataX, DataY, DataZ 为三维坐标点集*

    ```
    from DDDAGO import DDDA
    my_work = DDDA(DataF, DataX, DataY, DataZ)
    my_work.DDDARun()
    ```
    
我们提供了5个可以自定义的参数

    *其中InterLength代表差值点与数据点的比例关系（例如1.1为加密，0.9为稀疏），InterShift为边界处理算法的参数[0-1]默认为0.1，
    r0为自适应光滑算法计算域的尺寸参数，rn为自适应光滑算法计算域的尺寸参数，增大rn会带来更高的精度但计算速度会显著降低。Claster为聚类的分类数量。*

    ```
    from DDDAGO import DDDA
    my_work = DDDA(DataF, DataX, DataY, DataZ, InterLength = 1, \
               InterShift = 0.1, r0 = 3, rn = 10, Claster = 2)
    my_work.DDDARun()
    ```
    
### 算例    
我们在jupyter notebook中提供了简洁易读的测试算例:

- [2D Tubeflow](https://github.com/whoseboy/DDDA/tree/main/Examples/TubeFlow%202D)
- [3D Random Designed Case](https://github.com/whoseboy/DDDA/tree/main/Examples/Selfdefined%203Dcase)

测试算例的Matlab版本:
- [2D Tubeflow](https://github.com/whoseboy/DDDA/tree/989c8f1f55662becfd0f7311ec50d1b553e48806/Example/Matlab_DDDA%20for%20the%203D%20case）
- [3D Random Designed Case](https://github.com/whoseboy/DDDA/tree/989c8f1f55662becfd0f7311ec50d1b553e48806/Example/Matlab_DDDA%20for%20the%202D%20case%20(pressure%20drops%20in%20pipe%20flows))

☝️ *上述算例的详细信息可以看链接内文件夹中的readme文档*

## 关于本程序包

### 工作流程图
<p align="center">
<img src="https://github.com/whoseboy/DDDA/blob/main/docs/figures/TubeFlow2D/DDDA_FrameFlow.png" >
</p>
This package can evaluate the rest of work automatically if the reasearcher gets the data from experiment or simulation. The datasets could be acquired from varies sources, and of course in varies noise distribution and confidence interval.


### 部分算法解释

#### 自适应收敛光滑
基于径向基函数的原理，为了抑制数据的噪声，我们将每一个数据点都做了局部最佳优化。
<img src="https://github.com/whoseboy/DDDA/blob/main/docs/figures/Converge2.png" >
上图是我们示例数据中某一数据点的收敛判定。
图中，x轴代表光滑长度，其随x轴的增加而增大，y轴为抽象出来的收敛参数以0为判定基准。
左图中，红色的点为以欧式距离为标准，运用在本算法中得到的0阶距，其随光滑长度的增大而收敛。绿色点为1阶距的结果，其随光滑长度的增加而愈加远离判定基准。
这种交叉的趋势提供了最优收敛点，如右图所见，我们将两组数据组合后，选择了最小的计算域为此数据点的最佳收敛位置。

<img src="https://github.com/whoseboy/DDDA/blob/main/docs/figures/1n2Converge.png" >
上图为加入噪声后整场的收敛后数值的密度分布图。
左图为0阶距的整场密度分布，其标准值为1，可以看做光滑后数据与原数据的差异大小。右图为0阶距的密度分布，其标准值为0，代表了数据分布的混乱程度。
可见加入噪声后，本算法的自适应属性可以将每一个数据点赋予不同的收敛参数，以获得最佳效果。

<img src="https://github.com/whoseboy/DDDA/blob/main/docs/figures/DataDense.png" >
我们可以使用本算法对数据点进行加密操作，上图中，左侧为原数据点，右侧为加密后的数据点。

<p align="center">
<img src="https://github.com/whoseboy/DDDA/blob/main/docs/figures/TubeFlow2D/AdaptiveSmooth.png" >
</p>
上图为2维例子中，我们随机抽取6个差值点来展示算法结果。其中图例为当前位置对中心差值点的影响大小，可看做一个高斯分布。
可见，不同位置的差值点会随着其周围数值点（蓝色）的数量，分布情况来调整不同的计算域。

### 基于位置噪声的权重分配 
我们根据数据点的位置噪声，使用voronoi图的方式为每一数据点分配了权重。并在n维度数据点的voronoi cell边缘切割上提供了创新可靠的算法。
<p align="center">
<img src="https://github.com/whoseboy/DDDA/blob/main/docs/figures/TubeFlow2D/Voronoi.png">
</p>

## 流程概览 
我们以2维与3维算例为基础，按流程图的顺序向您展示我们代码中每一步骤的实现方法和巧思。

### 输入的数据结构


## FAQ

## 问题和支持
使用微信的朋友可以关注我们的微信公众号（智能科力实验室），将会有不定期的使用经验推送，以及加入微信群的方式，结识一起使用的好友；遇到问题也可以发送到公众号，我们在后台看到后会回复。
![扫码_搜索联合传播样式-白色版](https://github.com/whoseboy/DDDA/assets/34500062/26f30452-ea24-4bc9-b754-0efa98d7a193)

其他途径（包括并不限于论坛、微信群）还在建设中，请耐心等候。





## 正在开发中
v2.0.0 - 对噪声的传播进行定量化。

## 重要版本更新

**v1.6.0** 补充了Matlab代码，并更新了使用和安装说明。

**v1.5.0** 现在可以使用任意数量的数组参数了。除此之外还优化了用户自定义系数。

**v1.4.0** 确定了参数之间的相关性，减少了用户自定义参数，提高易用性

**v1.3.0** 重写了聚类算法，提升了聚类精度。提升了数据可视化程度

**v1.2.0** 更新收敛算法，从单一的0阶距提升到了高阶距

**v1.1.0** 数据结构优化

**v1.0.0** 改写MATLAB代码到Python

**v0.4.2** 完整的MATLAB下的三维代码实现

**v0.3.1** 截止到分区的MATLAB下的三维代码实现

**v0.2.0** 截止到分区的MATLAB下的二维代码实现


