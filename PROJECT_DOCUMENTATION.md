# 身份验证与授权系统 - 项目文档

## 📋 项目概览
- **项目名称**: `auth-system` 
- **描述**: Authentication and Authorization backend system
- **主要技术栈**: Node.js + Express + MongoDB + JWT
- **课程**: Application Security (应用安全)

## 🏗️ 项目架构
项目采用标准的MVC（Model-View-Controller）架构：

```
📁 项目结构
├── server.js                 # 主服务器入口
├── package.json              # 依赖配置
├── .gitignore                # Git忽略文件
├── Apsec_collection.json     # Postman集合文件
├── 📁 config/
│   └── db.js                 # MongoDB数据库连接配置
├── 📁 models/
│   └── User.js               # 用户数据模型
├── 📁 middleware/
│   └── auth.js               # JWT认证中间件
├── 📁 controllers/
│   └── authController.js     # 认证控制器
└── 📁 routes/
    ├── auth.js               # 通用认证路由
    ├── apsec.js              # APSEC特定路由
    ├── admin.js              # 管理员路由
    ├── manager.js            # 经理路由
    ├── analyst.js            # 分析师路由
    └── client.js             # 客户路由
```

## 🔐 核心功能

### 1. **用户角色系统**
支持8种不同的用户角色：
- **通用角色**: `admin`, `manager`, `analyst`, `client`
- **APSEC组织角色**: `president`, `secretary`, `treasurer`, `member`

### 2. **认证机制**
- **JWT Token认证**: 使用JSON Web Token进行用户身份验证
- **密码加密**: 使用bcryptjs进行密码哈希
- **Token过期时间**: 默认24小时

### 3. **授权控制**
- **基于角色的访问控制**(RBAC): 不同角色具有不同的权限
- **层级权限**: 某些高级角色可访问低级角色的资源

## 🛠️ 主要依赖
```json
{
  "express": "^4.18.2",        // Web框架
  "mongoose": "^8.0.0",        // MongoDB ODM
  "bcryptjs": "^2.4.3",        // 密码加密
  "jsonwebtoken": "^9.0.2",    // JWT实现
  "dotenv": "^16.3.1",         // 环境变量管理
  "axios": "^1.9.0"            // HTTP客户端
}
```

## 🌐 API端点结构

### **通用认证端点** (`/api/auth`)
- `POST /register` - 用户注册
- `POST /login` - 用户登录
- `GET /me` - 获取当前用户信息
- `GET /logout` - 用户登出

### **APSEC专用端点** (根路径)
- **注册端点**:
  - `POST /register-president`
  - `POST /register-secretary` 
  - `POST /register-treasurer`
  - `POST /register-member`
- **认证端点**:
  - `POST /login`
  - `POST /logout`
- **访问端点**:
  - `GET /public` (公开访问)
  - `GET /president-protected` (总裁专用)
  - `GET /secretary-protected` (秘书专用)
  - `GET /treasurer-protected` (财务专用)
  - `GET /member-protected` (成员专用)

### **角色特定端点**
- `/api/admin/dashboard` - 管理员仪表板
- `/api/manager/dashboard` - 经理仪表板  
- `/api/analyst/dashboard` - 分析师仪表板
- `/api/client/dashboard` - 客户仪表板

---

# 🎓 初学者指南 - 系统工作原理详解

## 🚀 快速开始

### 1. 安装依赖
```bash
npm install
```

### 2. 环境配置
创建 `.env` 文件并添加：
```env
MONGODB_URI=mongodb://localhost:27017/auth-system
JWT_SECRET=your-secret-key-here
JWT_EXPIRE=24h
PORT=5000
```

### 3. 启动应用
```bash
# 开发模式（自动重启）
npm run dev

# 生产模式
npm start
```

## 📊 系统工作流程图

```mermaid
graph TB
    A[客户端请求] --> B{请求类型}
    
    B -->|注册| C[注册流程]
    B -->|登录| D[登录流程]
    B -->|访问受保护资源| E[JWT验证流程]
    
    C --> C1[接收用户信息]
    C1 --> C2[验证邮箱格式]
    C2 --> C3[bcrypt加密密码]
    C3 --> C4[保存到MongoDB]
    C4 --> C5[生成JWT Token]
    C5 --> C6[返回Token和用户信息]
    
    D --> D1[接收邮箱密码]
    D1 --> D2[查询数据库]
    D2 --> D3[bcrypt验证密码]
    D3 --> D4[生成JWT Token]
    D4 --> D5[返回Token和用户信息]
    
    E --> E1[提取Bearer Token]
    E1 --> E2[JWT验证Token]
    E2 --> E3[查询用户信息]
    E3 --> E4[检查角色权限]
    E4 --> E5[允许或拒绝访问]
```

## 🔍 核心功能详解

### 1. 🔐 用户注册流程

#### 文件调用链：
```
客户端 POST /api/auth/register
    ↓
server.js (路由注册)
    ↓
routes/auth.js (路由处理)
    ↓
controllers/authController.js (register函数)
    ↓
models/User.js (创建用户)
    ↓
返回JWT Token
```

#### 详细步骤解释：

**步骤1: 客户端发送注册请求**
```javascript
// 客户端请求示例
POST http://localhost:5000/api/auth/register
{
    "name": "张三",
    "email": "zhangsan@example.com",
    "password": "123456",
    "role": "client"
}
```

**步骤2: 路由接收请求** (`routes/auth.js`)
```javascript
router.post('/register', register);
// 这里将请求传递给authController中的register函数
```

**步骤3: 控制器处理逻辑** (`controllers/authController.js`)
```javascript
exports.register = async (req, res) => {
    // 1. 从请求体获取用户数据
    const { name, email, password, role } = req.body;
    
    // 2. 检查用户是否已存在
    const existingUser = await User.findOne({ email });
    
    // 3. 创建新用户（这里会触发密码加密）
    const user = await User.create({
        name,
        email,
        password,  // 明文密码
        role
    });
    
    // 4. 生成并返回JWT Token
    sendTokenResponse(user, 200, res);
};
```

**步骤4: 密码加密** (`models/User.js`)
```javascript
// 在保存用户之前自动执行
UserSchema.pre('save', async function(next) {
    // 1. 生成盐值（随机字符串）
    const salt = await bcrypt.genSalt(10);
    
    // 2. 使用盐值加密密码
    this.password = await bcrypt.hash(this.password, salt);
    // 原密码: "123456" 
    // 加密后: "$2a$10$xxxxxxxxxxxxxxxxxxxxxxxxxxx"
});
```

**步骤5: 生成JWT Token**
```javascript
UserSchema.methods.getSignedJwtToken = function() {
    // JWT包含的信息（payload）
    const payload = { id: this._id };
    
    // 使用密钥签名生成Token
    return jwt.sign(payload, process.env.JWT_SECRET, {
        expiresIn: '24h'  // 24小时后过期
    });
};

// 生成的Token示例:
// eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYxNm...
```

### 2. 🔑 用户登录流程

#### 文件调用链：
```
客户端 POST /api/auth/login
    ↓
server.js
    ↓
routes/auth.js
    ↓
controllers/authController.js (login函数)
    ↓
models/User.js (matchPassword方法)
    ↓
返回JWT Token
```

#### 详细步骤：

**步骤1: 接收登录请求**
```javascript
// 客户端请求
POST http://localhost:5000/api/auth/login
{
    "email": "zhangsan@example.com",
    "password": "123456"
}
```

**步骤2: 验证用户身份** (`controllers/authController.js`)
```javascript
exports.login = async (req, res) => {
    const { email, password } = req.body;
    
    // 1. 查找用户（包含密码字段）
    const user = await User.findOne({ email }).select('+password');
    
    // 2. 验证密码
    const isMatch = await user.matchPassword(password);
    
    // 3. 如果匹配，返回Token
    if (isMatch) {
        sendTokenResponse(user, 200, res);
    }
};
```

**步骤3: 密码验证** (`models/User.js`)
```javascript
UserSchema.methods.matchPassword = async function(enteredPassword) {
    // bcrypt.compare会：
    // 1. 提取存储密码中的盐值
    // 2. 使用相同盐值加密输入的密码
    // 3. 比较两个哈希值是否相同
    return await bcrypt.compare(enteredPassword, this.password);
};
```

### 3. 🛡️ JWT身份验证流程

#### 文件调用链：
```
客户端访问受保护资源
    ↓
middleware/auth.js (protect中间件)
    ↓
验证JWT Token
    ↓
查询用户信息
    ↓
routes/[specific-route].js
    ↓
返回受保护资源
```

#### 详细步骤：

**步骤1: 客户端携带Token请求**
```javascript
// 客户端请求头
GET http://localhost:5000/api/admin/dashboard
Headers: {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**步骤2: 中间件验证Token** (`middleware/auth.js`)
```javascript
exports.protect = async (req, res, next) => {
    // 1. 从请求头提取Token
    let token;
    if (req.headers.authorization && 
        req.headers.authorization.startsWith('Bearer')) {
        token = req.headers.authorization.split(' ')[1];
    }
    
    // 2. 验证Token
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    // decoded = { id: '用户ID', iat: 签发时间, exp: 过期时间 }
    
    // 3. 查询用户信息
    const user = await User.findById(decoded.id);
    
    // 4. 将用户信息附加到请求对象
    req.user = user;
    
    // 5. 继续处理请求
    next();
};
```

**步骤3: 角色授权** (`middleware/auth.js`)
```javascript
exports.authorize = (...roles) => {
    return (req, res, next) => {
        // 检查用户角色是否在允许列表中
        if (!roles.includes(req.user.role)) {
            return res.status(403).json({
                error: `角色 ${req.user.role} 无权访问此资源`
            });
        }
        next();
    };
};
```

## 📁 文件关系图

```mermaid
graph TD
    A[server.js<br/>应用入口] --> B[routes/*<br/>路由定义]
    A --> C[config/db.js<br/>数据库连接]
    
    B --> D[controllers/*<br/>业务逻辑]
    B --> E[middleware/auth.js<br/>认证中间件]
    
    D --> F[models/User.js<br/>数据模型]
    E --> F
    
    F --> G[MongoDB<br/>数据库]
    
    H[.env<br/>环境变量] --> A
    H --> C
    
    style A fill:#f9f,stroke:#333,stroke-width:4px
    style F fill:#bbf,stroke:#333,stroke-width:2px
    style G fill:#bfb,stroke:#333,stroke-width:2px
```

## 🔒 安全机制详解

### 1. **密码安全存储**
```javascript
// 永远不存储明文密码！
明文密码: "123456"
    ↓ bcrypt加密
加密后: "$2a$10$N9qo8uLOickgx2ZMRZoMye3IjEPqH9c5JrXN4Ky8Mjw8oE1pZrKxm"

// 加密后的密码包含:
// $2a$ = bcrypt算法版本
// $10$ = 成本因子（越高越安全但越慢）
// 后面22个字符 = 盐值
// 最后31个字符 = 哈希值
```

### 2. **JWT Token结构**
```javascript
// JWT由三部分组成，用.分隔
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.  // Header（算法和类型）
eyJpZCI6IjYxNjE2MTYxNjE2MTYxNjE2MTYxNjE2MSIsImlhdCI6MTYzNDIwMDAwMCwiZXhwIjoxNjM0Mjg2NDAwfQ.  // Payload（数据）
SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c  // Signature（签名）

// 解码后的Payload:
{
    "id": "616161616161616161616161",  // 用户ID
    "iat": 1634200000,                 // 签发时间
    "exp": 1634286400                  // 过期时间
}
```

### 3. **请求-响应安全流程**
```
1. 注册/登录 → 获得JWT Token
2. 后续请求 → 在Header中携带Token
3. 服务器验证Token → 提取用户信息
4. 检查权限 → 允许或拒绝访问
5. Token过期 → 需要重新登录
```

## 💡 初学者常见问题

### Q1: 为什么要使用bcrypt而不是简单的哈希？
**答**: bcrypt具有以下优势：
- 自动加盐，每次加密结果不同
- 可调节成本因子，抵抗暴力破解
- 专门为密码存储设计，更安全

### Q2: JWT Token存储在哪里？
**答**: 客户端通常存储在：
- LocalStorage（简单但有XSS风险）
- SessionStorage（关闭浏览器后失效）
- HttpOnly Cookie（最安全，防XSS）

### Q3: 为什么密码字段有`select: false`？
**答**: 这确保查询用户时默认不返回密码字段，提高安全性。只有在需要验证密码时才明确查询。

### Q4: Token过期了怎么办？
**答**: 
- 用户需要重新登录
- 或实现refresh token机制（本项目未实现）

## 🧪 测试API

### 使用Postman测试：
1. 导入 `Apsec_collection.json` 文件
2. 设置环境变量 `{{base_url}}` 为 `http://localhost:5000`
3. 按顺序测试各个端点

### 测试流程示例：
```bash
# 1. 注册新用户
POST http://localhost:5000/api/auth/register
Content-Type: application/json
{
    "name": "测试用户",
    "email": "test@example.com",
    "password": "test123",
    "role": "client"
}

# 2. 登录获取Token
POST http://localhost:5000/api/auth/login
Content-Type: application/json
{
    "email": "test@example.com",
    "password": "test123"
}

# 3. 使用Token访问受保护资源
GET http://localhost:5000/api/client/dashboard
Authorization: Bearer [你的JWT Token]
```

## 📚 学习建议

1. **理解流程**：先理解整体流程，再深入细节
2. **动手实践**：使用Postman测试每个API
3. **查看日志**：在代码中添加console.log了解执行过程
4. **修改尝试**：尝试修改角色权限，理解授权机制
5. **安全思考**：思考可能的安全漏洞及防护方法

## 🎯 项目扩展建议

1. **添加更多功能**：
   - 密码重置功能
   - 邮箱验证
   - 登录日志记录

2. **提升安全性**：
   - 实现refresh token
   - 添加请求限流
   - 实现双因素认证

3. **优化用户体验**：
   - 添加用户资料更新
   - 实现记住登录状态
   - 添加登录设备管理

---

## 📖 总结

这个项目展示了现代Web应用中身份验证和授权的核心概念。通过学习这个项目，你可以理解：

- ✅ 如何安全地存储用户密码
- ✅ JWT Token的工作原理
- ✅ 基于角色的访问控制（RBAC）
- ✅ Express中间件的使用
- ✅ RESTful API设计原则

记住：**安全永远是第一位的！** 在实际项目中，始终遵循安全最佳实践。

祝学习愉快！ 🚀 