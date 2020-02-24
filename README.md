# VHDL實作介紹與紀錄
## 介紹
**VHDL**又稱為*超高速積體電路硬體描述語言*

( 英文：Very high-speed Hardware Description Language )

是用於數位邏輯設計中標準的硬體描述語言

▼ **執行機器** & **程式碼**

<img src="https://github.com/gigilin7/VHDL/blob/master/picture/%E9%82%8F%E8%A8%AD%E6%A9%9F%E5%99%A8.jpg" width=300 height=200><img src="https://github.com/gigilin7/VHDL/blob/master/picture/%E7%A8%8B%E5%BC%8F%E7%A2%BC.jpg" width=300 height=200>

## 成果1
### 題目：

<img src="https://github.com/gigilin7/VHDL/blob/master/picture/%E9%A1%8C%E7%9B%AE1.jpg" width=300>

### 目標：
```
變成在七段顯示器上顯示兩位數，從00數到59
```
### 心得：
```
在寫此題程式碼的過程中學習到如果要顯示出兩位數，除了要分開顯示個位數跟十位數，

也要控制兩位數交替顯示的變換速度，才能看起來像是有同時顯示兩位數。
```
+ 了解顯示器顯示數字的方式也相當重要(如下圖)

<img src="https://github.com/gigilin7/VHDL/blob/master/picture/%E9%A1%8C%E7%9B%AE1-1.jpg" height=200 width=200>

## 成果2
### 題目：

<img src="https://github.com/gigilin7/VHDL/blob/master/picture/%E9%A1%8C%E7%9B%AE2.jpg" width=300>

### 目標：
```
做成電梯的模式，在七段顯示器上顯示兩位數，從00到15，當按樓層數時，數字會往上數或往下數
```
### 心得：
```
這個題目有些複雜，除了要結合上次的實驗(同時顯示兩位數，並往上數)，還要做許多的改變，

像是要配合按下的數字去讓數字往上數或往下數都是一大挑戰，前前後後做了許多次修改，也學

到scan_code跟key_code的轉換方式，目前遇到一些編譯上的問題(像是if不能用巢狀組織去判

斷，when不能同時得出兩個結果)，待修改程式碼後，應該可以成功執行。
```
## 成果照片

<img src="https://github.com/gigilin7/VHDL/blob/master/picture/%E6%88%90%E6%9E%9C.jpg" width=300>
