# word2vec

    典型的聚类用法

[利用word2vec对关键词进行聚类](http://blog.csdn.net/jj12345jj198999/article/details/11069485)

1.  准备切词后的文本，每条一行
2.  训练

        word2vec -train yule.words.20150512.txt -output vectors.bin -cbow 0 -size 200 -window 5 -negative 0 -hs 1 -sample 1e-3 -threads 12 -binary 1


几个比较重要的参数：

*    –size:向量维数
*    –window:上下文窗口大小
*    –sample:高频词亚采样的阈值
*    –hs:是否采用层次 softmax
*    –negative:负例数目
*    –min-count:低频词阈值
*    –cbow:使用 CBOW 算法
*    -binary:结果是否以二进制保存

3.  聚类

        word2vec -train yule.words.20150512.txt -output classes.txt -cbow 0 -size 200 -window 10 -negative 0 -hs 1 -sample 1e-3 -threads 12 -classes 500