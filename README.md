# DupImageSearch
----------------
一个图像检索工程，主要是做近似重复图像检索，尝试各种方法（这里方法都不是自己实现，参考已开源方法）在部分公开数据集上的性能:
数据集 

1. [Fribourg Product Image Database](https://diuf.unifr.ch/diva/FPID/)

2. [Stanford Mobile Visual Search Dataset](http://blackhole1.stanford.edu/ivms/Datasets.htm#Stanford_Mobile_Visual_Search)

# method：
----------------
(1)feature representation：

1. 局部特征 ： SIFT + VLAD 

2. 局部特征 ： SIFT + Fisher Vector

3. HSV颜色直方图 ： Colorhist

4. HSV颜色矩 ： ColorMoment

5. CNN高层特征 ： cnn_fc7

(2)normalization

power law normalization

(3)hashing

some hasing method from  [hashing-baseline-for-image-retrieval](https://github.com/willard-yuan/hashing-baseline-for-image-retrieval)

(4)measure

cos distance or L2 distance

# cite：
----------------
代码主要用了
[MatConvNet](http://www.vlfeat.org/matconvnet) and
[VLFeat](http://www.vlfeat.org).
然后借鉴了
[CNN-for-Image-Retrieval](https://github.com/willard-yuan/CNN-for-Image-Retrieval).