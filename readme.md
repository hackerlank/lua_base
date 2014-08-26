所有文件都可以通过 require 来加载，会返回模块对象。但有个缺点是，所有对象都在 _G 表中，也就是污染的 _G 空间（尚未决定以后用什么方式更好）。)

### lib.lua
一些常用的基础函数（参考对象，quick-cocos2d 中的 function.lua）

* Lib:SplitStr(szStrConcat, szSet)
	* 将 szSet 依据分隔符 szStrConcat 变换成返回值 table
* Lib:ShowTB(tbVar, nCount)
	* 打印出 tbVar 的内容，tbVar 的类型必须是 table
* Lib:Copy(tbData)
	* 深度 copy tbData （实现的思路见代码）
* Lib:NewClass(tbBase, …)
	* 一种实现继承的方式
	* 子类会被包含在 _tbBase 中
	* 子类生成时会调用父类的 Init，然后再调用自己的 Init


###readfile
支持多种文件的读取，不用关心路径中的 \ 问题，自动转换

* tab.lua 读取 tab 文件，使用方法见文件

###random_list_sys

使用如下，这样即可得到一次随机列表中一定命中列表和随机列表
	
	local tbMustList = RandomListSys:GetMustList(nListId);
	local tbRandomList = RandomListSys:RandomOnce(nListId);

缺点是，没有做一个接口，将必须的，和随机的都放在一个列表里面