# 分组接口

# web

**请求预约项目列表** 
-----------

* **URL**

    /all-projects

* **Method**

    `GET`

* **URL Params**

    None

* **Data Params**

    None

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** 
    {
      [
        {
          "id":1,
          "name":"这个图书馆"
        },
        {
          "id":2,
          "name":"那个健身馆"
        }
        ...
      ]
    }

* **Error Response:**

  * **Code:** 422 Forbidden <br />
    **Content:** `{ error : "Invalid Params" }`


**创建分组** 
-----------

* **URL**

    /groups

* **Method**

    `POST`

* **URL Params**

    None

* **Data Params**

```JSON
    {
      "name":"图书馆",
      "projects":[1,2,3]
    }
```

* **Success Response:**

  * **Code:** 201 <br />
    **Content:** None

* **Error Response:**

  * **Code:** 422 Forbidden <br />
    **Content:** `{ error : "Invalid Params" }`

**修改分组** 
-----------

* **URL**

    /groups

* **Method**

    `PUT`

* **URL Params**

    None

* **Data Params**

```JSON
    {
      "id":1,
      "name":"图书馆_改名字",
      "projects":[1,2,3]
    }
```

* **Success Response:**

  * **Code:** 201 <br />
    **Content:** None

* **Error Response:**

  * **Code:** 422 Forbidden <br />
    **Content:** `{ error : "Invalid Params" }`

**删除分组** 
-----------

* **URL**

    /groups

* **Method**

    `DELETE`

* **URL Params**

    `id: 1`

* **Data Params**

    None

* **Success Response:**

  * **Code:** 201 <br />
    **Content:** None

* **Error Response:**

  * **Code:** 422 Forbidden <br />
    **Content:** `{ error : "Invalid Params" }`

**请求分组列表** 
-----------

* **URL**

    /groups

* **Method**

    `GET`

* **URL Params**

    None

* **Data Params**

    None

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** 
    {
      [
        {
          "id":1,
          "name":"图书馆"
        },
        {
          "id":2,
          "name":"健身馆"
        }
      ]
    }

* **Error Response:**

  * **Code:** 422 Forbidden <br />
    **Content:** `{ error : "Invalid Params" }`


**预约项目列表**
-------------------

* **URL**

    /projects

* **Method**

    `GET`

* **URL Params**

    **OPTIONAL:**

    `group=[integer]`

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

# 小程序

**请求分组内项目列表** 
-----------

* **URL**

    /miniprogram/projects

* **Method**

    `GET`

* **URL Params**

    **Required:**

   `page = [Interger]`
 
   `group=[Interger] group_id`

* **Data Params**

    None

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** 
    {
        count: 2,
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

* **Error Response:**

  * **Code:** 422 Forbidden <br />
    **Content:** `{ error : "Invalid Params" }`