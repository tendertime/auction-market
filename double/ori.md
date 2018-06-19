##1 初始化

声明全局变量
v:每个区域的用户数；  
w：  
Q_qrea：  4*4
p_area：4*4  
Q_min：  
Q_max：  
u_area: 每个用户所在的区域
q_area:   
x:  
fval:    
fval_n:300*4  
fvaly: 1*15  
fvaly_n:300*15  
y: 15*4  
num:  
mismatch:  
定义paruser
q_area_n:15*4*300  
Q_area_n:4*4*300  
p_area_n:4*4*300

 
##2 计算
针对每个区域i
取p_area的第i列  
取w_task的第i行：
取v的第i个元素：有~个用户  
用fmincon：装饰paruser的
输出为x的第i行和fval（i）
并赋值到Q_area的第i行
对于每个用户：
