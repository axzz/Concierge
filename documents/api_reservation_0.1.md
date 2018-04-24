# 预约接口 V0.1

**获得预约列表**
--------------

* **URL**

    /projects/:id/reservations

* **Method:**

  `GET`

*  **URL Params**

   **Optional:**

    `page = [integer]`
    
    `date_from = [String] 2018-04-23`

    `date_to = [String] 2018-04-23`

    `tel = [String]`

    `state = [String]`

* **Data Params**

  None

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** 
```JSON
{
    "reservations":[
      {"id": "预约id",
        "name": "用户名",
        "state": "预约状态",
        "tel": "电话号码",
        "date":"日期",
        "time": "时间段",
        "remark":"备注"},
      {"id": "预约id",
        "name": "用户名",
        "state": "预约状态",
        "tel": "电话号码",
        "date":"日期",
        "time": "时间段",
        "remark":"备注"}
    ]
}
```

* **Error Response:**

  * **Code:** 422 Forbidden <br />
    **Content:** `{ error : "Invalid Params" }`

  OR

  * **Code:** 401 UNAUTHORIZED <br />
    **Content:** `{ error : "No Permission" }`

**通过预约**
--------------

* **URL**

    /projects/:id/reservation/:id/pass

* **Method:**

  `POST`

*  **URL Params**

    None

* **Data Params**

    None

* **Success Response:**

  * **Code:** 201 <br />
    **Content:** ""

* **Error Response:**

  * **Code:** 401 UNAUTHORIZED <br />
    **Content:** `{ error : "No Permission" }`

  * **Code:** 403 Forbidden <br />
    **Content:** `{ error : "No Permission" }`


**拒绝预约**
--------------

* **URL**

    /projects/:id/reservation/:id/refuse

* **Method:**

  `POST`

*  **URL Params**

   **Required:**
 
   `remark=[String]`

* **Data Params**

    None

* **Success Response:**

  * **Code:** 201 <br />
    **Content:** ""

* **Error Response:**

  * **Code:** 401 UNAUTHORIZED <br />
    **Content:** `{ error : "No Permission" }`

  * **Code:** 403 Forbidden <br />
    **Content:** `{ error : "No Permission" }`

**取消预约**
-------------

* **URL**

    /projects/:id/reservation/:id/cancel

* **Method:**

  `POST`

*  **URL Params**

   **Required:**
 
   `remark=[String]`

* **Data Params**

    None

* **Success Response:**

  * **Code:** 201 <br />
    **Content:** ""

* **Error Response:**

  * **Code:** 401 UNAUTHORIZED <br />
    **Content:** `{ error : "No Permission" }`

  * **Code:** 403 Forbidden <br />
    **Content:** `{ error : "No Permission" }`

**核销预约**
------------

* **URL**

    /projects/:id/reservation/:id/check

* **Method:**

  `POST`

*  **URL Params**

    None

* **Data Params**

    None

* **Success Response:**

  * **Code:** 201 <br />
    **Content:** ""

* **Error Response:**

  * **Code:** 401 UNAUTHORIZED <br />
    **Content:** `{ error : "No Permission" }`

  * **Code:** 403 Forbidden <br />
    **Content:** `{ error : "No Permission" }`