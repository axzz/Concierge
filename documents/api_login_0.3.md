# 登录接口 V0.3

V0.3改动：

经过修改后，token现在在后台不进行保存，后台只进行其存活更新的服务

前端应每次将token随请求的header “AUTHORIZATION”字段 将后台给予的token发送，并且从后台回传请求的header中“AUTHORIZATION”字段获得更新存活日期后的token

改动后，不再在body中返回state字段，浏览器应从http status code中获得请求状态，若返回错误代码（401/404等），则从body中error可获得原因

---------

**请求短信登录** 
-----------

* **URL**

    /code

* **Method**

    `POST`

* **URL Params**

    **Required:**
 
   `tel=[string]`

* **Data Params**

    None

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** None

* **Error Response:**

  * **Code:** 403 Forbidden <br />
    **Content:** `{ error : "Invalid Params" }`

**验证短信** 
-----------

* **URL**

    /login

* **Method**

    `POST`

* **URL Params**

    **Required:**
 
   `tel=[string]`

   `code=[string]`

* **Data Params**

    None

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** None

* **Error Response:**

  * **Code:** 403 Forbidden <br />
    **Content:** `{ error : "Invalid Params" }`


**登出**
---------- 

* 登出现在不由后台负责处理，通过前端删除cookie进行。