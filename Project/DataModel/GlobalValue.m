//
//  GlobalValue.m
//  huazhuangjiaocheng
//
//  Created by kun on 2017/6/10.
//  Copyright © 2017年 kun. All rights reserved.
//

#import "GlobalValue.h"


NSString* files[][7] = {

    {@"XODUyNjYzOTAw.jpg", @"钢琴的基础知识", @"XODUyNjYzOTAw", @"08:38", @"0590", @"", @""},
    {@"XODUzNTkyNjcy.jpg", @"钢琴的识谱与节奏", @"XODUzNTkyNjcy", @"08:14", @"0590", @"", @""},
    {@"XODU1MTQ5ODQ0.jpg", @"10分钟学会双手演奏欢乐颂", @"XODU1MTQ5ODQ0", @"11:33", @"0590", @"", @""},
    {@"XODY1ODQ2OTQ4.jpg", @"钢琴的乐句中的呼吸", @"XODY1ODQ2OTQ4", @"07:07", @"0590", @"", @""},
    {@"XODY1OTE5NzI0.jpg", @"钢琴的钢琴演奏中的和弦", @"XODY1OTE5NzI0", @"05:56", @"0590", @"", @""},
    {@"XODY2NjY1MDI4.jpg", @"轻松学会双手演奏生日歌", @"XODY2NjY1MDI4", @"07:54", @"0590", @"", @""},
    {@"XODc0NDExMjU2.jpg", @"如何演奏附点音符", @"XODc0NDExMjU2", @"10:14", @"0590", @"", @""},
    {@"XODc1MDEwMDEy.jpg", @"五线谱的升号和还原", @"XODc1MDEwMDEy", @"09:51", @"0590", @"", @""},
    {@"XODc1MDE2ODk2.jpg", @"巩固知识点练习曲《送别》", @"XODc1MDE2ODk2", @"04:38", @"0590", @"", @""},
    {@"XOTA2MjA5MDgw.jpg", @"巩固练习曲《致爱丽丝》上", @"XOTA2MjA5MDgw", @"08:52", @"0590", @"", @""},
    {@"XOTA2NjgyMzQ4.jpg", @"巩固练习曲《致爱丽丝》下", @"XOTA2NjgyMzQ4", @"10:24", @"0590", @"", @""},
    {@"XOTA3MzYxODA4.jpg", @"轻松学会《雪绒花》", @"XOTA3MzYxODA4", @"09:48", @"0590", @"", @""},
    {@"XMTcyNDE3NTMzNg==.jpg", @"轻松学会《康康舞曲》", @"XMTcyNDE3NTMzNg==", @"09:42", @"0590", @"", @""},
    {@"XMTcyNzIwNzU0OA==.jpg", @"轻松学会《G大调小步舞曲》", @"XMTcyNzIwNzU0OA==", @"08:40", @"0590", @"", @""},
    {@"XMTczMzg5Nzc0OA==.jpg", @"轻松学会《土耳其进行曲》", @"XMTczMzg5Nzc0OA==", @"08:26", @"0590", @"", @""},
    {@"XMTgwNDk3NzQwMA==.jpg", @"轻松学会《拉德茨基进行曲》", @"XMTgwNDk3NzQwMA==", @"11:58", @"0590", @"", @""},
    {@"XMTg2NzY5MzU0OA==.jpg", @"轻松学会《军队进行曲》", @"XMTg2NzY5MzU0OA==", @"15:54", @"0590", @"", @""},
    {@"XMTg4OTI4ODkwNA==.jpg", @"轻松学会《南国玫瑰圆舞曲》", @"XMTg4OTI4ODkwNA==", @"13:31", @"0590", @"", @""},
    {@"XMjQ3OTgyNzUyOA==.jpg", @"轻松学会门德尔松·《婚礼进行曲》", @"XMjQ3OTgyNzUyOA==", @"10:09", @"0590", @"", @""},
    {@"XMjg0ODY3MDk5Ng==.jpg", @"轻松学会勃拉姆斯·《摇篮曲》", @"XMjg0ODY3MDk5Ng==", @"10:20", @"0590", @"", @""},
    {@"XMTU3ODc5ODI0NA==.jpg", @"五线谱入门及谱号介绍了解音与乐谱种类", @"XMTU3ODc5ODI0NA==", @"12:34", @"0590", @"", @""},
    {@"XMTU4MDc5ODg5Ng==.jpg", @"五线谱入门及谱号介绍", @"XMTU4MDc5ODg5Ng==", @"08:37", @"0590", @"", @""},
    {@"XMTU4MTQwMjMzMg==.jpg", @"音的组别介绍", @"XMTU4MTQwMjMzMg==", @"13:01", @"0590", @"", @""},
    {@"XMTU4NDU0ODI1Mg==.jpg", @"音符的区别介绍", @"XMTU4NDU0ODI1Mg==", @"13:58", @"0590", @"", @""},
    {@"XMTU5MDkyMDE4OA==.jpg", @"复习课", @"XMTU5MDkyMDE4OA==", @"14:19", @"0590", @"", @""},
    {@"XMTYwNTM2NzI2MA==.jpg", @"节奏与节拍", @"XMTYwNTM2NzI2MA==", @"13:51", @"0590", @"", @""},
    {@"XMTYwNTY5ODEwNA==.jpg", @"常用节拍种类", @"XMTYwNTY5ODEwNA==", @"13:25", @"0590", @"", @""},
    {@"XMTYwNzk5OTg1Ng==.jpg", @"节奏与节拍的组合介绍", @"XMTYwNzk5OTg1Ng==", @"18:17", @"0590", @"", @""},
    {@"XMTYxODk1Nzc1Mg==.jpg", @"八六拍及不同指挥图示介绍", @"XMTYxODk1Nzc1Mg==", @"18:54", @"0590", @"", @""},
    {@"XMTYxOTAzMzQ0NA==.jpg", @"前五节课复习", @"XMTYxOTAzMzQ0NA==", @"14:26", @"0590", @"", @""},
    {@"XMTYxOTA2MjYwNA==.jpg", @"节奏创作与即兴", @"XMTYxOTA2MjYwNA==", @"13:22", @"0590", @"", @""},
    {@"XMTYyMzk2OTgyMA==.jpg", @"移动小节线与即兴创作", @"XMTYyMzk2OTgyMA==", @"09:33", @"0590", @"", @""},
    {@"XMTYyNzUxOTg2OA==.jpg", @"切分节奏与音值组合", @"XMTYyNzUxOTg2OA==", @"16:40", @"0590", @"", @""},
    {@"XMTYzMzY3MDU4NA==.jpg", @"附点节奏型与乐曲讲解", @"XMTYzMzY3MDU4NA==", @"19:21", @"0590", @"", @""},
    {@"XMTY1MzM1NDA5Ng==.jpg", @"复习讲解【小草】【送别】", @"XMTY1MzM1NDA5Ng==", @"18:54", @"0590", @"", @""},
    {@"XMTY1NzUyMTc1Ng==.jpg", @"休止符的名称、应用与即兴", @"XMTY1NzUyMTc1Ng==", @"17:28", @"0590", @"", @""},
    {@"XMTY2NjU3NTM0MA==.jpg", @"常用意大利术语及《青花瓷》钢琴示范", @"XMTY2NjU3NTM0MA==", @"18:37", @"0590", @"", @""},
    {@"XMTY3NzM0NzI0MA==.jpg", @"玩玩黑键《沧海笑》钢琴示范", @"XMTY3NzM0NzI0MA==", @"19:38", @"0590", @"", @""},
    {@"XMTY4NTMxMDQxMg==.jpg", @"自然与变化的半音、全音《土耳其进行曲&幻想即兴曲》", @"XMTY4NTMxMDQxMg==", @"17:17", @"0590", @"", @""},
    {@"XMTY5NjI0Mjc5Ng==.jpg", @"复习讲解《致爱丽丝》", @"XMTY5NjI0Mjc5Ng==", @"14:38", @"0590", @"", @""},
    {@"XMTcwODU1Mzg2OA==.jpg", @"什么叫调？什么是自然大调音阶？钢琴示范：《谁》", @"XMTcwODU1Mzg2OA==", @"18:45", @"0590", @"", @""},
    {@"XMTY5NjIzNDE2MA==.jpg", @"自然小调音阶。钢琴示范：《a小调》", @"XMTY5NjIzNDE2MA==", @"17:45", @"0590", @"", @""},
    {@"XMTcyNTIxOTYxMg==.jpg", @"和声、旋律大、小调。钢琴示范：《我的太阳》、《莫斯科郊外的晚上》", @"XMTcyNTIxOTYxMg==", @"21:27", @"0590", @"", @""},
    {@"XMTczMTU0MDA1Ng==.jpg", @"泛音列与音程、和弦等钢琴曲《茉莉花》《鸿雁》", @"XMTczMTU0MDA1Ng==", @"21:54", @"0590", @"", @""},
    {@"XMTczNzI4NTg4OA==.jpg", @"复习课：讲解《爱的罗曼史》和弦与层次", @"XMTczNzI4NTg4OA==", @"15:14", @"0590", @"", @""},
    {@"XMTc0OTg5MTU0OA==.jpg", @"讲解音的属性与罗马标记", @"XMTc0OTg5MTU0OA==", @"15:47", @"0590", @"", @""},
    {@"XMTc2MzI3OTk0OA==.jpg", @"调与调号", @"XMTc2MzI3OTk0OA==", @"16:21", @"0590", @"", @""},
    {@"XMTgwOTExMTU0MA==.jpg", @"一起来创作简单旋律", @"XMTgwOTExMTU0MA==", @"18:54", @"0590", @"", @""},
    {@"XMTgyNTcxNDkyMA==.jpg", @"复习与分析", @"XMTgyNTcxNDkyMA==", @"09:23", @"0590", @"", @""},
    {@"XMTgzMTY5NTIzMg==.jpg", @"音程的性质", @"XMTgzMTY5NTIzMg==", @"19:12", @"0590", @"", @""},
    {@"XMTg0MDg4MzQwNA==.jpg", @"音程的分类转位等", @"XMTg0MDg4MzQwNA==", @"22:54", @"0590", @"", @""},
    {@"XMTg1MTY5MjY5Ng==.jpg", @"和弦的种类与性质", @"XMTg1MTY5MjY5Ng==", @"17:39", @"0590", @"", @""},
    {@"XMTg1ODA2NDc2OA==.jpg", @"和弦的转位与解决", @"XMTg1ODA2NDc2OA==", @"19:49", @"0590", @"", @""},
    {@"XMTg2ODgxMjMyMA==.jpg", @"复习课", @"XMTg2ODgxMjMyMA==", @"17:23", @"0590", @"", @""},
    {@"XMTg3NzI3MDI4OA==.jpg", @"节奏节拍新的形式", @"XMTg3NzI3MDI4OA==", @"23:12", @"0590", @"", @""},
    {@"XMTkyODI5NjAzMg==.jpg", @"记号的讲解", @"XMTkyODI5NjAzMg==", @"19:26", @"0590", @"", @""},
    {@"XMjI2NTY3ODM0MA==.jpg", @"移调", @"XMjI2NTY3ODM0MA==", @"18:16", @"0590", @"", @""},
    {@"XMjQ3ODU1NjMwOA==.jpg", @"复习与歌曲创作", @"XMjQ3ODU1NjMwOA==", @"18:03", @"0590", @"", @""},
    {@"XMjQ5MDg4OTA2OA==.jpg", @"中国的五声音阶", @"XMjQ5MDg4OTA2OA==", @"16:26", @"0590", @"", @""},
    {@"XMjQ5OTkzODQ2OA==.jpg", @"中国的七声音阶", @"XMjQ5OTkzODQ2OA==", @"13:20", @"0590", @"", @""},
    {@"XMjUxMDkwMzc1Ng==.jpg", @"西方的中古调式", @"XMjUxMDkwMzc1Ng==", @"18:23", @"0590", @"", @""},
    {@"XMjU1MzQ4NjgxMg==.jpg", @"简谱", @"XMjU1MzQ4NjgxMg==", @"18:41", @"0590", @"", @""},
    {@"XMjYxNDY5MTQxNg==.jpg", @"中外调式的对比", @"XMjYxNDY5MTQxNg==", @"27:26", @"0590", @"", @""},
    {@"XMjY0NDY3OTYwMA==.jpg", @"和弦（通过三和弦来判断调）", @"XMjY0NDY3OTYwMA==", @"18:01", @"0590", @"", @""},
    {@"XMjY1OTgyMTg0MA==.jpg", @"和弦（通过七和弦来判断调）", @"XMjY1OTgyMTg0MA==", @"19:04", @"0590", @"", @""},
    {@"XMjY5ODg2OTgxMg==.jpg", @"等（等音、等音调、等音程、等和弦）", @"XMjY5ODg2OTgxMg==", @"30:22", @"0590", @"", @""},
    {@"XMjcxMDgwMzc0NA==.jpg", @"调的串讲", @"XMjcxMDgwMzc0NA==", @"20:29", @"0590", @"", @""},
    {@"XMjc0NjU3NjI4MA==.jpg", @"如何判断调式调性", @"XMjc0NjU3NjI4MA==", @"22:54", @"0590", @"", @""},
    {@"XMjc2MzYzMzkyOA==.jpg", @"入门", @"XMjc2MzYzMzkyOA==", @"23:45", @"0590", @"", @""},
    {@"XMjc4MDYyODc1Mg==.jpg", @"音名", @"XMjc4MDYyODc1Mg==", @"14:44", @"0590", @"", @""},
    {@"XMjc5NTk3MDcwNA==.jpg", @"不同音符时值", @"XMjc5NTk3MDcwNA==", @"22:58", @"0590", @"", @""},
    {@"XMjgxNTczOTUzMg==.jpg", @"不同音符时值（二）", @"XMjgxNTczOTUzMg==", @"16:39", @"0590", @"", @""},
    {@"XMjg0NjQ5NjIwMA==.jpg", @"复习课", @"XMjg0NjQ5NjIwMA==", @"15:39", @"0590", @"", @""},
    {@"XMTY1MTIwNDY3Mg==.jpg", @"贝加尔湖畔", @"XMTY1MTIwNDY3Mg==", @"", @"0590", @"", @""},
    {@"XMTU4MTI2MzQ0OA==.jpg", @"铃儿响叮当", @"XMTU4MTI2MzQ0OA==", @"", @"0590", @"", @""},
    {@"XMTU4Mzg4OTQ0OA==.jpg", @"菊花台", @"XMTU4Mzg4OTQ0OA==", @"", @"0590", @"", @""},
    {@"XMTYwMTE2Nzg2NA==.jpg", @"同桌的你", @"XMTYwMTE2Nzg2NA==", @"", @"0590", @"", @""},
    {@"XMTYzOTg4OTE0NA==.jpg", @"天空之城", @"XMTYzOTg4OTE0NA==", @"", @"0590", @"", @""},
    {@"XMTYzOTg5MTY4OA==.jpg", @"致爱丽丝", @"XMTYzOTg5MTY4OA==", @"", @"0590", @"", @""},
    {@"XMTY1MTE5NjU3Mg==.jpg", @"青春修炼手册", @"XMTY1MTE5NjU3Mg==", @"", @"0590", @"", @""},
    {@"XMTY1MTE5ODQ4MA==.jpg", @"送别", @"XMTY1MTE5ODQ4MA==", @"", @"0590", @"", @""},
    {@"XMTY1MTE5OTU2OA==.jpg", @"突然想爱你", @"XMTY1MTE5OTU2OA==", @"", @"0590", @"", @""},
    {@"XMTY1MTIwMjU2NA==.jpg", @"夜的钢琴曲", @"XMTY1MTIwMjU2NA==", @"", @"0590", @"", @""},
    {@"XMTU4MTIxNTg2MA==.jpg", @"遇见", @"XMTU4MTIxNTg2MA==", @"", @"0590", @"", @""},
    {@"XODgwMzM4ODg0.jpg", @"进行曲", @"XODgwMzM4ODg0", @"", @"0590", @"", @""},
    {@"XODgwMzM4ODc2.jpg", @"快速进行曲", @"XODgwMzM4ODc2", @"", @"0590", @"", @""},
    {@"XODgwMzM4ODky.jpg", @"士兵进行曲", @"XODgwMzM4ODky", @"", @"0590", @"", @""},
    {@"XODgwMzU2NzQw.jpg", @"D大调进行曲", @"XODgwMzU2NzQw", @"", @"0590", @"", @""},
    {@"XODgwMzU3MTU2.jpg", @"舞曲", @"XODgwMzU3MTU2", @"", @"0590", @"", @""},
    {@"XODgwMzU5NTI0.jpg", @"G大调苏格兰舞曲", @"XODgwMzU5NTI0", @"", @"0590", @"", @""},
    {@"XODgwMzcyNjQ4.jpg", @"F小调小步舞曲", @"XODgwMzcyNjQ4", @"", @"0590", @"", @""},
    {@"XODgwMzc1Nzc2.jpg", @"G大调小步舞曲2", @"XODgwMzc1Nzc2", @"", @"0590", @"", @""},
    {@"XODgwMzc5ODEy.jpg", @"G大调小步舞曲1", @"XODgwMzc5ODEy", @"", @"0590", @"", @""},
    {@"XODgwMzc5ODM2.jpg", @"G小调小步舞曲", @"XODgwMzc5ODM2", @"", @"0590", @"", @""},
    {@"XOTM0NTAxNTYw.jpg", @"右手和弦的练习", @"XOTM0NTAxNTYw", @"", @"0590", @"", @""},
    {@"XOTM0NTAyMTky.jpg", @"C手位的练习", @"XOTM0NTAyMTky", @"", @"0590", @"", @""},
    {@"XOTM0NDk5NzA4.jpg", @"长音&四分音符的流动乐句", @"XOTM0NDk5NzA4", @"", @"0590", @"", @""},
    {@"XOTM0NDk4MzY4.jpg", @"四分音符的练习", @"XOTM0NDk4MzY4", @"", @"0590", @"", @""},
    {@"XOTI5NTE1NDc2.jpg", @"相隔一个八度的C把位练习", @"XOTI5NTE1NDc2", @"", @"0590", @"", @""},
    {@"XOTI5NDk4MDE2.jpg", @"双手G把位练习", @"XOTI5NDk4MDE2", @"", @"0590", @"", @""},
    {@"XOTI5NDk5Mjky.jpg", @"左手C把位&右手G把位练习", @"XOTI5NDk5Mjky", @"", @"0590", @"", @""},
    {@"XMTYzOTg2NjcxMg==.jpg", @"六度音的练习", @"XMTYzOTg2NjcxMg==", @"", @"0590", @"", @""},
    {@"XMTYzOTg2NDMyOA==.jpg", @"右手琶音的练习", @"XMTYzOTg2NDMyOA==", @"", @"0590", @"", @""},
    {@"XMTYzOTg1ODg2MA==.jpg", @"和弦、踏板与力度的结合", @"XMTYzOTg1ODg2MA==", @"", @"0590", @"", @""},
    {@"XMTYzOTg1MTczNg==.jpg", @"八度音的演奏", @"XMTYzOTg1MTczNg==", @"", @"0590", @"", @""},
    {@"XMTYzOTg0NTcwOA==.jpg", @"跳音的练习", @"XMTYzOTg0NTcwOA==", @"", @"0590", @"", @""},
    {@"XMTYzOTgzNzk2MA==.jpg", @"三度音的演奏", @"XMTYzOTgzNzk2MA==", @"", @"0590", @"", @""},
    {@"XMTYzOTgyOTg0OA==.jpg", @"右手4、5指的灵活练习", @"XMTYzOTgyOTg0OA==", @"", @"0590", @"", @""},
    {@"XMTYzOTgxOTE1Ng==.jpg", @"三连音与和弦的演奏", @"XMTYzOTgxOTE1Ng==", @"", @"0590", @"", @""},
    {@"XMTYzOTc5ODMzMg==.jpg", @"手指间的统一", @"XMTYzOTc5ODMzMg==", @"", @"0590", @"", @""},
    {@"XMTY1MTIxOTQwOA==.jpg", @"手指不灵活怎么办?", @"XMTY1MTIxOTQwOA==", @"", @"0590", @"", @""},
    {@"XMTYzOTg3MzM0OA==.jpg", @"如何提高钢琴视奏能力?", @"XMTYzOTg3MzM0OA==", @"", @"0590", @"", @""},
    {@"XMTYzOTg3OTMyNA==.jpg", @"如何提高练琴的效率?", @"XMTYzOTg3OTMyNA==", @"", @"0590", @"", @""},
    {@"XMTY1MTIxMDEyMA==.jpg", @"如何练习弹奏八度?", @"XMTY1MTIxMDEyMA==", @"", @"0590", @"", @""},
    {@"XMTY1MTIxMTI4NA==.jpg", @"什么是和弦?", @"XMTY1MTIxMTI4NA==", @"", @"0590", @"", @""},
    {@"XMTY1MTIxMjc4OA==.jpg", @"八度够不到怎么办?", @"XMTY1MTIxMjc4OA==", @"", @"0590", @"", @""},
    {@"XMTY1MTIyMTU0OA==.jpg", @"弹钢琴的坐姿与手型", @"XMTY1MTIyMTU0OA==", @"", @"0590", @"", @""},
    {@"XMTY1MTIyNDgxNg==.jpg", @"初学钢琴时如何触键?", @"XMTY1MTIyNDgxNg==", @"", @"0590", @"", @""},
    {@"XMTY1MTIyNjQ3Ng==.jpg", @"如何正确使用钢琴踏板?", @"XMTY1MTIyNjQ3Ng==", @"", @"0590", @"", @""},
    {@"XMTY1MTIxMzc5Ng==.jpg", @"如何快速识别调号?", @"XMTY1MTIxMzc5Ng==", @"", @"0590", @"", @""},
    {@"XMTY1MTIyMzQxMg==.jpg", @"折指怎样纠正?", @"XMTY1MTIyMzQxMg==", @"", @"0590", @"", @""},
    {@"XMTY1MTIxMTc0NA==.jpg", @"左右手合不上怎么办?", @"XMTY1MTIxMTc0NA==", @"", @"0590", @"", @""},
    {@"XMTYzOTg2OTE4OA==.jpg", @"4、5指不灵活怎么办?", @"XMTYzOTg2OTE4OA==", @"", @"0590", @"", @""},
    {@"XMTM4NzQ3MjAxMg==.jpg", @"李斯特：第三號「帕格尼尼」大練習曲(鐘)", @"XMTM4NzQ3MjAxMg==", @"04:24", @"0590", @"", @""},
    {@"XMTM4NzQ3MjM1Ng==.jpg", @"李斯特匈牙利狂想曲第2号", @"XMTM4NzQ3MjM1Ng==", @"10:51", @"0590", @"", @""},
    {@"XMTM4NzQ3MzA3Mg==.jpg", @"柴可夫斯基《十八首钢琴小品》冥想曲作品72", @"XMTM4NzQ3MzA3Mg==", @"05:35", @"0590", @"", @""},
    {@"XMTM4NzQ3NTA4OA==.jpg", @"柴可夫斯基圆舞曲德沙龙作品51号", @"XMTM4NzQ3NTA4OA==", @"04:31", @"0590", @"", @""},
    {@"XMTM4NzQ3NTE2MA==.jpg", @"柴可夫斯基协奏曲第1号", @"XMTM4NzQ3NTE2MA==", @"35:47", @"0590", @"", @""},
    {@"XMTM4NzQ3Njk0MA==.jpg", @"柴科夫斯基F大调创作主题与变奏曲作品19第6首", @"XMTM4NzQ3Njk0MA==", @"10:41", @"0590", @"", @""},
    {@"XMTM4NzQ3NzcyNA==.jpg", @"肖邦-根据莫扎特“唐璜”降B大调主题变奏曲作品2号", @"XMTM4NzQ3NzcyNA==", @"16:13", @"0590", @"", @""},
    {@"XMTM4NzQ4NzE1Ng==.jpg", @"肖邦练习曲于A小调作品10号第二首", @"XMTM4NzQ4NzE1Ng==", @"01:30", @"0590", @"", @""},
    {@"XMTM4NzQ4ODE5Ng==.jpg", @"莫扎特钢琴协奏曲第23号", @"XMTM4NzQ4ODE5Ng==", @"26:41", @"0590", @"", @""},
    {@"XMTM4NzQ4ODk0NA==.jpg", @"贝多芬钢琴奏鸣曲作品-111", @"XMTM4NzQ4ODk0NA==", @"20:49", @"0590", @"", @""},
    {@"XMTM4NDcxNTU0NA==.jpg", @"黎卓宇在第三轮(决赛)表演", @"XMTM4NDcxNTU0NA==", @"1:07:29", @"0590", @"", @""},
    {@"XMTM4NDc0MjU2OA==.jpg", @"黎卓宇在第一轮(初赛)全部表演", @"XMTM4NDc0MjU2OA==", @"47:15", @"0590", @"", @""},
    {@"XMTM4NDc0MjU4NA==.jpg", @"黎卓宇在获奖者音乐会表演", @"XMTM4NDc0MjU4NA==", @"09:04", @"0590", @"", @""},
    {@"XMTM4NDc0Mjc0MA==.jpg", @"黎卓宇在第二轮(复赛)独奏", @"XMTM4NDc0Mjc0MA==", @"56:40", @"0590", @"", @""},
    {@"XMTM4NDc0OTU4OA==.jpg", @"莫扎特钢琴协奏曲", @"XMTM4NDc0OTU4OA==", @"26:41", @"0590", @"", @""},
    {@"XMTM4NzQ3MDA2MA==.jpg", @"巴赫前奏曲与赋格曲G小调", @"XMTM4NzQ3MDA2MA==", @"06:20", @"0590", @"", @""},
    {@"XMTM4NzQ3MDEwNA==.jpg", @"普罗科菲耶夫第三钢琴协奏曲C大调", @"XMTM4NzQ3MDEwNA==", @"31:40", @"0590", @"", @""},
    {@"XMTM4NzQ3MDE3Mg==.jpg", @"拉赫玛尼诺夫：科雷利主题变奏曲", @"XMTM4NzQ3MDE3Mg==", @"17:57", @"0590", @"", @""},
    {@"XMTM4NzQ3MTUyMA==.jpg", @"拉赫玛尼诺夫《音画练习曲》", @"XMTM4NzQ3MTUyMA==", @"01:51", @"0590", @"", @""},
    {@"XNjU2ODU3NzA4.jpg", @"梦中的婚礼", @"XNjU2ODU3NzA4", @"03:09", @"0590", @"", @""},
    {@"XNjU2ODU3ODQ0.jpg", @"小时代主题曲时间煮雨", @"XNjU2ODU3ODQ0", @"04:26", @"0590", @"", @""},
    {@"XNjU2ODU3ODUy.jpg", @"经典钢琴曲somewhereintime", @"XNjU2ODU3ODUy", @"04:00", @"0590", @"", @""},
    {@"XNjU2ODU5NDk2.jpg", @"我的歌声里", @"XNjU2ODU5NDk2", @"03:02", @"0590", @"", @""},
    {@"XNjU2ODU5ODg0.jpg", @"卡农", @"XNjU2ODU5ODg0", @"02:32", @"0590", @"", @""},
    {@"XNjU2ODYwMDQw.jpg", @"少女的祈祷", @"XNjU2ODYwMDQw", @"02:57", @"0590", @"", @""},
    {@"XNjU3MDQyMTEy.jpg", @"三寸天堂", @"XNjU3MDQyMTEy", @"03:45", @"0590", @"", @""},
    {@"XNjU3MDM1MTk2.jpg", @"天空之城", @"XNjU3MDM1MTk2", @"03:38", @"0590", @"", @""},
    {@"XODc1NjIxMjYw.jpg", @"小镇姑娘", @"XODc1NjIxMjYw", @"06:00", @"0590", @"", @""},
    {@"XODc1NjIxOTMy.jpg", @"钢琴学习必看-《小镇姑娘》钢琴演奏技巧-高清02", @"XODc1NjIxOTMy", @"06:50", @"0590", @"", @""},
    {@"XOTYxNjEwNDU2.jpg", @"最终幻想9钢琴曲", @"XOTYxNjEwNDU2", @"00:40", @"0590", @"", @""},
    {@"XOTYxNjI5NDIw.jpg", @"beauty钢琴曲", @"XOTYxNjI5NDIw", @"01:03", @"0590", @"", @""},
    {@"XOTYxNjQzODA4.jpg", @"疯狂摇滚版钢琴曲卡农", @"XOTYxNjQzODA4", @"04:01", @"0590", @"", @""},
    {@"XOTYzOTczODEy.jpg", @"不能说的秘密", @"XOTYzOTczODEy", @"00:53", @"0590", @"", @""},
    {@"XOTY0NzM4NzYw.jpg", @"平凡之路", @"XOTY0NzM4NzYw", @"02:36", @"0590", @"", @""},
    {@"XOTY0NzY5MTk2.jpg", @"夜夜夜夜", @"XOTY0NzY5MTk2", @"03:18", @"0590", @"", @""},
    {@"XMTI0ODY0MzExMg==.jpg", @"加勒比海盗钢琴曲", @"XMTI0ODY0MzExMg==", @"01:55", @"0590", @"", @""},
    {@"XMTM1MzA5ODMxMg==.jpg", @"挥着翅膀的女孩", @"XMTM1MzA5ODMxMg==", @"02:44", @"0590", @"", @""},
    {@"XMTM1MzE0NDYxMg==.jpg", @"再见青春", @"XMTM1MzE0NDYxMg==", @"03:40", @"0590", @"", @""},
    {@"XMTM1MzIyMjA0OA==.jpg", @"南山南钢琴曲", @"XMTM1MzIyMjA0OA==", @"02:33", @"0590", @"", @""},
    {@"XMTM1MzI4NjA4NA==.jpg", @"钢琴曲《匆匆那年》", @"XMTM1MzI4NjA4NA==", @"03:23", @"0590", @"", @""},
    {@"XMTM1NDY1MjgyNA==.jpg", @"钢琴曲野蜂飞舞", @"XMTM1NDY1MjgyNA==", @"03:06", @"0590", @"", @""},
    {@"XMTM1NDc2NTA0NA==.jpg", @"钢琴曲《亡灵序曲》", @"XMTM1NDc2NTA0NA==", @"02:02", @"0590", @"", @""},
    {@"XMTM1NDgxMzE0OA==.jpg", @"《加勒比海盗》钢琴曲超好听", @"XMTM1NDgxMzE0OA==", @"02:04", @"0590", @"", @""},
    {@"XMjUzNjAwNjAw.jpg", @"韦伯的降E大调辉煌回旋曲", @"XMjUzNjAwNjAw", @"06:17", @"0590", @"", @""},
    {@"XMjUzNTY2OTI4.jpg", @"莫什科夫斯基第6号F大调练习曲", @"XMjUzNTY2OTI4", @"01:23", @"0590", @"", @""},
    {@"XMjUzNTM5NDAw.jpg", @"巴托克钢琴奏鸣曲", @"XMjUzNTM5NDAw", @"12:20", @"0590", @"", @""},
    {@"XMjM1OTA1MzA0.jpg", @"黎卓宇个人音乐会", @"XMjM1OTA1MzA0", @"54:11", @"0590", @"", @""},
    {@"XMjM1OTAyMjYw.jpg", @" GoyescasElpelele", @"XMjM1OTAyMjYw", @"04:37", @"0590", @"", @""},
    {@"XMjM1ODg1MTY4.jpg", @"GinasteraDanzasArgentinas", @"XMjM1ODg1MTY4", @"02:51", @"0590", @"", @""},
    {@"XMjM1ODg1NjYw.jpg", @"殷承宗教拉威尔海洋欧莱雅河畔三桅帆船", @"XMjM1ODg1NjYw", @"06:50", @"0590", @"", @""},
    {@"XMjM1ODgwMjEy.jpg", @"弹奏拉威尔的Alboradadelgracioso", @"XMjM1ODgwMjEy", @"06:07", @"0590", @"", @""},
    {@"XMjM1ODYyMjI0.jpg", @"格什温的前奏曲", @"XMjM1ODYyMjI0", @"04:59", @"0590", @"", @""},
    {@"XMjM1ODU4MTY4.jpg", @"向阳花", @"XMjM1ODU4MTY4", @"11:30", @"0590", @"", @""},
    {@"XMjM1ODU4MDMy.jpg", @"德彪西的三首前奏曲", @"XMjM1ODU4MDMy", @"09:30", @"0590", @"", @""},
    {@"XMjI2MjIwNDY0.jpg", @"车尔尼以罗德曲为主题的变奏曲", @"XMjI2MjIwNDY0", @"07:08", @"0590", @"", @""},
    {@"XMjU0NDg1NTg4.jpg", @"奥菲斯的主题歌：幽灵祝福舞", @"XMjU0NDg1NTg4", @"03:33", @"0590", @"", @""},
    {@"XMjU2MTA0NTk2.jpg", @"黎卓宇和金丹尼四手联弹", @"XMjU2MTA0NTk2", @"06:26", @"0590", @"", @""},
    {@"XMjU2NzEwNTE2.jpg", @"贝多芬第23号F小调奏鸣曲-热情", @"XMjU2NzEwNTE2", @"21:12", @"0590", @"", @""},
    {@"XMjY1MTQ5NDIw.jpg", @"斯卡拉蒂D小调奏鸣曲K141", @"XMjY1MTQ5NDIw", @"03:14", @"0590", @"", @""},
    {@"XMjY2Nzk5OTEy.jpg", @"李斯特第三号安慰曲", @"XMjY2Nzk5OTEy", @"03:43", @"0590", @"", @""},
    {@"XMjY3MTM5MDQw.jpg", @"肖邦第一号叙事曲", @"XMjY3MTM5MDQw", @"09:16", @"0590", @"", @""},
    {@"XMjcxMTMwNjA4.jpg", @"拉威尔镜子集中的AlboradaDelGracioso", @"XMjcxMTMwNjA4", @"06:35", @"0590", @"", @""},
    {@"XMjcxMzQ3MTQw.jpg", @"黎卓宇表演李斯特的钟（LaCAMPANELLA）", @"XMjcxMzQ3MTQw", @"05:02", @"0590", @"", @""},
    {@"XMjcxMzQ3ODUy.jpg", @"黎卓宇表演李斯特的第二号匈牙利狂想曲", @"XMjcxMzQ3ODUy", @"09:28", @"0590", @"", @""},
    {@"XMjM1ODU4MDM2.jpg", @"李斯特第十一号匈牙利狂想曲", @"XMjM1ODU4MDM2", @"06:19", @"0590", @"", @""},
    {@"XMjcxNjUxNDAw.jpg", @"黎卓宇在“利兹•沃克”电视秀直播演奏", @"XMjcxNjUxNDAw", @"05:17", @"0590", @"", @""},
    {@"XMjcxNjUzNTYw.jpg", @"黎卓宇的音乐履程", @"XMjcxNjUzNTYw", @"15:29", @"0590", @"", @""},
    {@"XMjcxNjU1NjI0.jpg", @"黎卓宇直播演奏", @"XMjcxNjU1NjI0", @"04:31", @"0590", @"", @""},
    {@"XMjcyMDA5OTIw.jpg", @"李斯特音乐会练习曲Waldesranschenn", @"XMjcyMDA5OTIw", @"04:03", @"0590", @"", @""},
    {@"XMjcyMDY5OTU2.jpg", @"莫扎特K330C大调奏鸣曲", @"XMjcyMDY5OTU2", @"12:31", @"0590", @"", @""},
    {@"XMjcyMDc5MTI4.jpg", @"门德尔松纺织歌", @"XMjcyMDc5MTI4", @"01:37", @"0590", @"", @""},
    {@"XMjcyMDk4OTE2.jpg", @"斯卡拉蒂E大调奏鸣曲K380", @"XMjcyMDk4OTE2", @"04:14", @"0590", @"", @""},
    {@"XMjkyODgzNDQ0.jpg", @"贝多芬钢琴协奏曲第四号", @"XMjkyODgzNDQ0", @"40:05", @"0590", @"", @""},
    {@"XMjkzMjQzMDUy.jpg", @"拉赫曼尼诺夫第二号钢琴协奏曲", @"XMjkzMjQzMDUy", @"43:51", @"0590", @"", @""},
    {@"XMjkzMjQ1MDM2.jpg", @"野蜂飞舞", @"XMjkzMjQ1MDM2", @"01:04", @"0590", @"", @""},
    {@"XMjk0Nzc4MDM2.jpg", @"黎卓宇贝多芬第23号F小调（热情）奏鸣曲", @"XMjk0Nzc4MDM2", @"23:46", @"0590", @"", @""},
    {@"XMjk0Nzc4MTQw.jpg", @"舒伯特的C大调幻想曲“流浪者幻想曲”", @"XMjk0Nzc4MTQw", @"20:02", @"0590", @"", @""},
    {@"XMzA1MzU2NjI0.jpg", @"李斯特音乐会练习曲Gnomenreigen", @"XMzA1MzU2NjI0", @"02:43", @"0590", @"", @""},
    {@"XMzA2MjAxMTI4.jpg", @"李斯特音乐会练习曲Waldesrauschen.", @"XMzA2MjAxMTI4", @"04:04", @"0590", @"", @""},
    {@"XMzA5Mjg3Njcy.jpg", @"黎卓宇个人音乐会", @"XMzA5Mjg3Njcy", @"1:17:00", @"0590", @"", @""},
    {@"XMzExMzExMDE2.jpg", @"格什温钢琴协奏曲-蓝色狂想曲", @"XMzExMzExMDE2", @"31:14", @"0590", @"", @""},
    {@"XMzMxMjIzNDg0.jpg", @"黎卓宇温哥华钢琴独奏音乐会(十六岁）", @"XMzMxMjIzNDg0", @"1:25:59", @"0590", @"", @""},
    {@"XMzMzNTE0MzIw.jpg", @"[喜庆的日子]", @"XMzMzNTE0MzIw", @"01:31", @"0590", @"", @""},
    {@"XMzM0MTIyOTU2.jpg", @"山丹丹开花红艳艳", @"XMzM0MTIyOTU2", @"04:42", @"0590", @"", @""},
    {@"XMzQxNjYxMzQ0.jpg", @"勋伯格的六首钢琴曲", @"XMzQxNjYxMzQ0", @"06:32", @"0590", @"", @""},
    {@"XMzQxNjYxNDMy.jpg", @"车尔尼的罗德变奏曲", @"XMzQxNjYxNDMy", @"07:35", @"0590", @"", @""},
    {@"XMzQxNjYxOTA4.jpg", @"拉威尔镜子集中的“悲伤鸟”", @"XMzQxNjYxOTA4", @"03:48", @"0590", @"", @""},
    {@"XMzQxNjYyNDM2.jpg", @"拉威尔镜子集中的“小丑晨曲”", @"XMzQxNjYyNDM2", @"06:25", @"0590", @"", @""},
    {@"XMzQxNjYyNTQ4.jpg", @"李斯特第三号安慰曲", @"XMzQxNjYyNTQ4", @"04:11", @"0590", @"", @""},
    {@"XMzQxNjYzMjk2.jpg", @"李斯特两首音乐会练习曲", @"XMzQxNjYzMjk2", @"06:55", @"0590", @"", @""},
    {@"XMzQxNjYzNzg0.jpg", @"索罗提改编巴赫的序曲", @"XMzQxNjYzNzg0", @"03:45", @"0590", @"", @""},
    {@"XMzQxNjYzODgw.jpg", @"贝多芬的“热情”奏鸣曲", @"XMzQxNjYzODgw", @"23:48", @"0590", @"", @""},
    {@"XMzQxNjYzOTEy.jpg", @"李斯特匈牙利狂想曲第二号", @"XMzQxNjYzOTEy", @"11:21", @"0590", @"", @""},
    {@"XMzQxNjY0MDY4.jpg", @"李斯特的“钟”LaCompanella", @"XMzQxNjY0MDY4", @"04:43", @"0590", @"", @""},
    {@"XMzQ3NjM0NzQ0.jpg", @"黎卓宇在美国艺术节的钢琴音乐会(十六岁）", @"XMzQ3NjM0NzQ0", @"1:14:26", @"0590", @"", @""},
    {@"XODM3NzUwNTMy.jpg", @"肖邦練習曲作品10第4", @"XODM3NzUwNTMy", @"02:04", @"0590", @"", @""},
    {@"XODM4MjU1ODE2.jpg", @"肖邦瑪祖卡作品24第1", @"XODM4MjU1ODE2", @"03:02", @"0590", @"", @""},
    {@"XODM4MjQ5OTY4.jpg", @"霍洛維茨的從卡門主題變奏曲", @"XODM4MjQ5OTY4", @"03:49", @"0590", @"", @""},
    {@"XODM4MjY0NTg0.jpg", @"肖邦瑪祖卡作品24第2", @"XODM4MjY0NTg0", @"02:12", @"0590", @"", @""},
    {@"XODM4MjY0ODM2.jpg", @"肖邦瑪祖卡作品24第3", @"XODM4MjY0ODM2", @"02:26", @"0590", @"", @""},
    {@"XODM4MjY1NjI4.jpg", @"拉威爾 圓舞曲", @"XODM4MjY1NjI4", @"11:24", @"0590", @"", @""},
    {@"XODM4MjY4MTgw.jpg", @"勳伯格", @"XODM4MjY4MTgw", @"10:36", @"0590", @"", @""},
    
    
};

@implementation VideoObject

@end

@interface GlobalValue () {
    NSMutableDictionary *dictionary;
    NSMutableArray *videoArray;
}
@end

@implementation GlobalValue

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init {
    self = [super init];
    if(self){
        dictionary = [NSMutableDictionary dictionary];
        videoArray = [NSMutableArray array];
        int total = sizeof(files)/sizeof(files[0]);
        for(int i = 0; i < total; i++){
            VideoObject *object = [VideoObject new];
            object.videoPath = nil;
            object.previewPath = nil;
            object.icon = files[i][0];
            object.title = files[i][1];
            object.uid = files[i][2];
            object.time = files[i][3];
            object.code = files[i][4];
            object.clent_id = files[i][5];
            object.password = files[i][6];
            object.index = i;
            [videoArray addObject:object];
        }
    }
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *sqlFilePath = [path stringByAppendingPathComponent:@"history.sqlite"];
    _db = [FMDatabase databaseWithPath:sqlFilePath];
    return self;
}

- (BOOL)openHistoryDb {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *sqlFilePath = [path stringByAppendingPathComponent:@"history.sqlite"];
    // 1.通过路径创建数据库
    self.db = [FMDatabase databaseWithPath:sqlFilePath];
    
    // 2.打开数据库
    if ([self.db open]) {
        NSLog(@"打开HistoryDb成功");
        BOOL success = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_history (id integer PRIMARY KEY AUTOINCREMENT, uid text NOT NULL, title text, preview text);"];
        if (success) {
            NSLog(@"创建表成功");
        } else {
            NSLog(@"创建表失败");
            [self.db close];
            return NO;
        }
    } else {
        NSLog(@"打开HistoryDb失败");
        return NO;
    }
    return YES;
}

- (void)historySave:(NSString *)uid {
    if (![self openHistoryDb]) {
        return;
    }
    
    NSString *cmd = @"DELETE FROM t_history WHERE uid==";
    cmd = [cmd stringByAppendingString:@"'"];
    cmd = [cmd stringByAppendingString:uid];
    cmd = [cmd stringByAppendingString:@"';"];
    NSLog(@"%s cmd: %@", __func__, cmd);
    
    BOOL success = [self.db executeUpdate:cmd];
    if (success) {
        NSLog(@"删除成功: %@", uid);
    } else {
        NSLog(@"删除失败: %@", uid);
    }
    success = [self.db executeUpdate:@"INSERT INTO t_history (uid) VALUES (?);", uid];
    if (success) {
        NSLog(@"插入成功: %@", uid);
    } else {
        NSLog(@"插入失败: %@", uid);
    }
    [self.db close];
}

- (NSMutableArray *)historyView {
    NSMutableArray *ret = [NSMutableArray array];
    if(![self openHistoryDb]) {
        return ret;
    }
    
    // 查询数据
    FMResultSet *result = [self.db executeQuery:@"SELECT id, uid FROM t_history;"];
    while ([result next]) {
        //int ID = [result intForColumnIndex:0];
        NSString *uid = [result stringForColumnIndex:1];
        //NSLog(@"ID: %zd, name: %@", ID, uid);
        [ret addObject:uid];
    }
    //NSLog(@"NSMutableArray: %@", ret);
    [self.db close];
    return ret;
}

- (void)setImageUrl:(NSString *)key Obj:(GlobalObject *)object {
    if(key && object) {
        [dictionary setObject:object forKey:key];
    }
}

- (GlobalObject *)getImageUrl:(NSString *)key {
    GlobalObject *obj = nil;
    if(key == nil)
        return nil;
    obj = [dictionary objectForKey:key];
    //NSLog(@"get key: %@,value: %@", key, obj);

    return obj;
}

- (int)VideoObjectsCount {
    return sizeof(files)/sizeof(files[0]);
}

- (NSMutableArray *)getVideoObjects:(long )start End:(long)end {
    long total = sizeof(files)/sizeof(files[0]);
    NSMutableArray *ret = [NSMutableArray array];
    if(start > end || start > total || end > total) {
        return ret;
    }
    for(long i = start; i < end; i++) {
        VideoObject *object = [videoArray objectAtIndex:i];
        [ret addObject:object];
    }
    return ret;
}

- (NSMutableArray *)keySearchForObjects:(NSString *)key {
    NSMutableArray *ret = [NSMutableArray array];
    int total = sizeof(files)/sizeof(files[0]);
    for(int i = 0; i < total; i++) {
        VideoObject *object = [videoArray objectAtIndex:i];
        if([object.title containsString:key]) {
            VideoObject *object = [videoArray objectAtIndex:i];
            [ret addObject:object];
        }
    }
    return ret;
}

- (VideoObject *)getVideoObject:(NSString *)uid {
    VideoObject *obj = nil;
    int total = sizeof(files)/sizeof(files[0]);
    for(int i = 0; i < total; i++) {
        VideoObject *object = [videoArray objectAtIndex:i];
        if([object.uid isEqualToString:uid]){
            obj = object;
            break;
        }
    }
    return obj;
}

- (VideoObject *)getVideoObjectWithIndex:(long )index {
    VideoObject *obj = nil;
    int total = sizeof(files)/sizeof(files[0]);
    if(index < 0 || index > (total - 1)) {
        return obj;
    }
    obj = [videoArray objectAtIndex:index];
    return obj;
}

- (long)getVideoObjectIndex:(NSString *)uid {
    long ret = -1;
    int total = sizeof(files)/sizeof(files[0]);
    for(int i = 0; i < total; i++) {
        VideoObject *object = [videoArray objectAtIndex:i];
        if([object.uid isEqualToString:uid]) {
            ret = i;
            break;
        }
    }
    return ret;
}

- (void)updateVideoObject:(NSString *)uid Object:(VideoObject *)obj {
    int total = sizeof(files)/sizeof(files[0]);
    for(int i = 0; i < total; i++) {
        VideoObject *object = [videoArray objectAtIndex:i];
        if([object.uid isEqualToString:uid]) {
            object.videoPath = obj.videoPath;
            object.previewPath = obj.previewPath;
            object.title = obj.title;
            object.time = obj.time;
            object.uid = obj.uid;
            object.code = obj.code;
            object.subUrl = obj.subUrl;
            break;
        }
    }
}

@end
