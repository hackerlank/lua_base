使用如下，这样即可得到一次随机列表中一定命中列表和随机列表
- local tbMustList = RandomListSys:GetMustList(nListId);
- local tbRandomList = RandomListSys:RandomOnce(nListId);

缺点是，没有做一个接口，将必须的，和随机的都放在一个列表里面