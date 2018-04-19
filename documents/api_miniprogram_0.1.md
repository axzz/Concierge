# 小程序普通用户端接口 V0.1

**获取token**
-----------
小程序token不会过期

除了这个接口外，所有接口请在header中携带token
* **URL**

    /miniprogram/login

* **Method**

    `POST`

* **URL Params**

    None

* **Data Params**

    **Require:**

    `code = [String] 通过wx.login 获得的code`

* **Success Response:**

  * **Code:** 200 <br/>
    **Content:** 
    `{"token":"token","role":"manager/customer"}`

* **Error Response:**

  * **Code:** 422 Unprocessable Entity <br />
    **Content:** `{ error : "Invalid Params" }`

  * **Code:** 400 Bad request <br />
    **Content:** `{ error : "Bad request" }`

**获得项目列表** 
-----------
若不添加参数，默认所有项目(without distance or 经纬度)/默认为第一页(without page)

* **URL**

    /miniprogram/projects

* **Method**

    `GET`

* **URL Params**

    **Optional:**

    `search = [String] 当使用搜索时，默认不再判断距离`
    
    `distance = [Float] 单位为千米`

    `latitude = [Float]`

    `longtitude = [Float]`

    `page = [Interger]`

* **Data Params**

    None

* **Success Response:**

  * **Code:** 200 <br/>
    **Content:** 
    ```JSON
    {
        "projects" : [{
            "id" : 1,
            "cover" : "url",
            "name" : "项目名称",
            "address" : "可能为空"
            },
            {
            "id" : 2,
            "cover" : "url",
            "name" : "项目名称",
            "address" : ""
            }
        ]
    }
    ```

* **Error Response:**

  * **Code:** 422 Forbidden <br />
    **Content:** `{ error : "Invalid Params" }`



**获得单一项目** 
-----------

* **URL**

    /miniprogram/projects/:id

* **Method**

    `GET`

* **URL Params**

    None

* **Data Params**

    None

* **Success Response:**

  * **Code:** 200 <br/>
    **Content:** 
    ```JSON
    {
        "cover" : "url",
        "name" : "项目名称",
        "description" : "项目描述",
        "address" : "可能为空",
        "latitude" : "经度 Float",
        "longtitude" : "维度 Float",
        "time_state" : "可预约时间，详见下",
        "time_table" : "目前预约时间表，详见下",
        "tmp_name" : "用户上次使用的名字",
        "tmp_tel" : "用户上次使用的电话号码"
    }
    ```

    ```JSON
    # time_state:
    {
        "Mon":[{"time" : "09:00-12:00", "limit" : 10},{"time" : "13:00-17:00", "limit": 20}],
        "Tues":["若此数组为空，请不要渲染"],
        "Wed":[{"time" : "09:00-12:00", "limit" : 10},{"time" : "13:00-17:00", "limit": 20}],
        "Thur":[],
        "Fri":[{"time" : "09:00-12:00", "limit" : 10},{"time" : "13:00-17:00", "limit": 20}],
        "Sat":[],
        "Sun":[],
        "Holiday":[],
        "Special":["暂无设计，第一期请勿做"]
    }
    ```

    ```JSON
    {
        "time_table" : [
            {"date":"2018-4-11",
                "wday" : "周三",
                "table":[
                {"time":"09:00-12:00","remain":9},
                {"time":"13:00-17:00","remain":15}
                ]},
            {"date":"2018-4-13",
                "wday" : "周五",
                "table":[
                {"time":"09:00-12:00","remain":10},
                {"time":"13:00-17:00","remain":0}
            ]}
        ]
    }
    ```

* **Error Response:**

  * **Code:** 422 Forbidden <br />
    **Content:** `{ error : "Invalid Params" }`

**预约短信**
----------
* **URL**

    /miniprogram/project/:id/code

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

  * **Code:** 422  <br />
    **Content:** `{ error : "Invalid Params" }`

**发起预约** 
-----------
* **URL**

    /miniprogram/reservations

* **Method:**

  `POST`

*  **URL Params**

    None

* **Data Params**

```JSON
{
    "code":"短信验证码",
    "project_id":"项目id",
    "name":"张三",
    "tel":"18888888888",
    "date":"2018-04-17",
    "time":"09:00-10:00"
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
    **Content:** `{ error : "Error sms code" }`

  OR

  * **Code:** 403 Forbidden <br />
    **Content:** `{ error : "ERROR in create reservation" }`


**查询预约列表** 
-----------
* **URL**

    /miniprogram/reservations

* **Method:**

  `GET`

*  **URL Params**

    **Optional:**

    `page = [Interger]`

    `search = [String]`

    `type = [String]`

    type为'current','finished','cancelled','refused' 对应四个页面

* **Data Params**

    None

* **Success Response:**

  * **Code:** 201 <br/>
    **Content:** 
    ```JSON
    {
        "reservations":[
            {
                "id":1,
                "state" : "success等 见注1",
                "project_name" : "成华区图书馆",
                "address" : "天益街高新区",
                "date" : "2018-03-10",
                "time" : "09:00-12:00",
                "name" : "张三",
                "tel" : "18888888888"
            }
        ]
    }
    ```

* **Error Response:**

  * **Code:** 422 Forbidden <br />
    **Content:** `{ error : "Invalid Params" }`

  OR

  * **Code:** 401 UNAUTHORIZED <br />
    **Content:** `{ error : "No Permission" }`

  OR

  * **Code:** 403 Forbidden <br />
    **Content:** `{ error : "ERROR in create reservation" }`


**查询单一预约** 
-----------
* **URL**

    /miniprogram/reservations/:id

* **Method:**

  `GET`

*  **URL Params**

    None

* **Data Params**

    None

* **Success Response:**

  * **Code:** 201 <br/>
    **Content:** 
    ```JSON
    {
        "state" : "success等 见注1",
        "project_name" : "成华区图书馆",
        "address" : "天益街高新区",
        "latitude" : "经度",
        "longitude" : "纬度",
        "share_code" : "现在版本还没有",
        "date" : "2018-03-10",
        "time" : "09:00-12:00",
        "name" : "张三",
        "tel" : "18888888888"
    }
    ```

* **Error Response:**

  * **Code:** 422 Forbidden <br />
    **Content:** `{ error : "Invalid Params" }`

  OR

  * **Code:** 401 UNAUTHORIZED <br />
    **Content:** `{ error : "No Permission" }`

  OR

  * **Code:** 403 Forbidden <br />
    **Content:** `{ error : "ERROR in create reservation" }`
