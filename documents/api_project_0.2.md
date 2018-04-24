# 预约项目接口 V0.3

V0.3

根据token与rest更新，通过http status code传输请求回馈

并且一律通过header传输token，不再使用变量验明身份

------------

**创建预约项目** 
-----------

* **URL**

    /projects

* **Method**

    `POST`

* **URL Params**

    None

* **Data Params**

```JSON
{
    "name": "项目名称",
    "description": "项目详情",
    "image": "图片相对路径",
    "address":"详细地址",
    "latitude": "经度(float)",
    "longtitude":"纬度(float)",
    "time_state":"未经处理的时间表JSON(详见下)",
    "check_mode":"auto or manual",
}
```

```JSON
#time_state(未经处理):

{
    "normal":[
        {"time": "09:00-10:00", "limit": 10, "weekday": ["Sat","Sun"]},
        {"time": "11:00-12:00", "limit": 10, "weekday": ["Mon","Tues","Wed","Thur","Fri"]},
        {"time": "14:00-16:00", "limit": 10, "weekday": ["Holiday"]}
    ],
    "special":[
        {"Date":"2018-04-03","state": "open" , "time_table":[{"time":"9:00-10:30","limit": 100},{"time":"11:30-13:00","limit": 200}]},
        {"Date":"2018-05-01","state": "close" }
    ]
}
```

* **Success Response:**

  * **Code:** 201 <br/>
    **Content:** None

* **Error Response:**

  * **Code:** 422 Forbidden <br />
    **Content:** `{ error : "Invalid Params" }`

  OR

  * **Code:** 401 UNAUTHORIZED <br />
    **Content:** `{ error : "No Permission" }`


**预约项目列表**
-------------------


* **URL**

    /projects

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

**获得预约项目**
--------------

* **URL**

    /projects/:id

* **Method:**

  `GET`

*  **URL Params**

   **Required:**
 
   `id=[integer]`

* **Data Params**

  None

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** 
```JSON
{
    "name": "项目名称",
    "description": "项目详情",
    "image": "图片相对路径",
    "address":"详细地址",
    "latitude":"经度(float)",
    "longtitude":"纬度(float)",
    "time_state": "未经处理的时间表JSON(详见创建预约项目)",
    "check_mode":"auto or manual",
}
```

* **Error Response:**

  * **Code:** 422 Forbidden <br />
    **Content:** `{ error : "Invalid Params" }`

  OR

  * **Code:** 401 UNAUTHORIZED <br />
    **Content:** `{ error : "No Permission" }`

**修改预约项目**
--------------

* **URL**

    /projects/:id

* **Method:**

  `PUT`

*  **URL Params**

   **Required:**
 
   `id=[integer]`

* **Data Params**

```JSON
{
    "name": "项目名称",
    "description": "项目详情",
    "image": "图片相对路径",
    "address":"详细地址",
    "latitude": "经度(float)",
    "longtitude":"纬度(float)",
    "time_state":"未经处理的时间表JSON(详见创建预约项目)",
    "check_mode":"auto or manual",
}
```

* **Success Response:**

  * **Code:** 201 <br/>
    **Content:** None

* **Error Response:**

  * **Code:** 422 Forbidden <br />
    **Content:** `{ error : "Invalid Params" }`

  OR

  * **Code:** 401 UNAUTHORIZED <br />
    **Content:** `{ error : "No Permission" }`

**获取默认封面列表**
-------------------

* **URL**

    /covers

* **Method:**

  `GET`

*  **URL Params**

   None

* **Data Params**

    None

* **Success Response:**

  * **Code:** 200 <br/>
    **Content:** `{ images : ["/static/images/img1.ipg"] }`


**上传图片**
-------------------

* **URL**

    /image

* **Method:**

  `POST`

*  **URL Params**

   None

* **Data Params**

    `{ image: "图片文件"}`

* **Success Response:**

  * **Code:** 201 <br/>
    **Content:** `{ image : "/static/images/img1.ipg" }`

* **Error Response:**

  * **Code:** 422 Forbidden <br />
    **Content:** `{ error : "Invalid Params" }`

**暂停预约项目**
--------------

* **URL**

    /projects/:id/pause

* **Method:**

  `GET`

*  **URL Params**

    None

* **Data Params**

    None

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** ""

* **Error Response:**

  * **Code:** 401 UNAUTHORIZED <br />
    **Content:** `{ error : "No Permission" }`

  * **Code:** 403 Forbidden <br />
    **Content:** `{ error : "No Permission" }`

**开启预约项目**
--------------

* **URL**

    /projects/:id/open

* **Method:**

  `GET`

*  **URL Params**

    None

* **Data Params**

    None

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** ""

* **Error Response:**

  * **Code:** 401 UNAUTHORIZED <br />
    **Content:** `{ error : "No Permission" }`

  * **Code:** 403 Forbidden <br />
    **Content:** `{ error : "No Permission" }`