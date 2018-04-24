# 小程序管理员端接口 V0.1
除了前两个接口外，其他调用用户都应是管理员

**账号注册-获得短信验证码** 
-----------

* **URL**

    /miniprogram/admin/code

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

  * **Code:** 400 Forbidden <br />
    **Content:** `{ error : "Error in sending msg" }`

  * **Code:** 403 Forbidden <br />
    **Content:** `{ error : "Tel have been used" }`

  * **Code:** 422 Forbidden <br />
    **Content:** `{ error : "Invalid Params" }`


**账号注册-验证验证码**
---------------

* **URL**

    /miniprogram/admin/login

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

**预约项目列表**
-------------------

* **URL**

    /miniprogram/admin/projects

* **Method**

    `GET`

* **URL Params**

    **OPTIONAL:**

    `page=[integer]`

* **Data Params**

    None

* **Success Response:**

  * **Code:** 200 <br/>
    **Content:** 
```JSON
{
    "count": "2(总预约数量 num类型)",
    "projects": [
        {"id":111,"name":"标题","image":"图片url","state":"open"},
        {"id":208,"name":"标题","image":"图片url","state":"close"}
    ]
}
```

* **Error Response:**

  * **Code:** 422 Forbidden <br />
    **Content:** `{ error : "Invalid Params" }`

  OR

  * **Code:** 401 UNAUTHORIZED <br />
    **Content:** `{ error : "No Permission" }`