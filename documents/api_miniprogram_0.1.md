# 小程序接口 V0.1

**获取token**
-----------
* **URL**

    /miniprogram/login

* **Method**

    `GET`

* **URL Params**

    **Require:**

    `code = [String] 通过wx.login 获得的code`

* **Data Params**

    None

* **Success Response:**

  * **Code:** 200 <br/>
    **Content:** 
    `{"token":"token"}`

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
        "count" : 77,
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
        "time_table" : "目前预约时间表，详见下"
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

**短信登录** 
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
    
**发起预约** 
-----------
**查询预约列表** 
-----------
**查询单一预约** 
-----------