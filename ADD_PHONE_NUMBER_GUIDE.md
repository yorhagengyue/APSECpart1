# 📱 添加手机号字段到注册功能 - 实践指南

## 🎯 任务目标
在现有的用户注册系统中添加一个新的字段：**手机号（phone）**

## 📋 需要修改的文件
1. `models/User.js` - 添加手机号字段到数据模型
2. `controllers/authController.js` - 处理手机号数据
3. `routes/apsec.js` - APSEC相关路由（如果需要）

## 🚀 实现步骤

### 步骤1：修改用户模型 (`models/User.js`)

找到 `UserSchema` 定义部分，在 `email` 字段后面添加 `phone` 字段：

```javascript
const UserSchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, 'Please add a name']
  },
  username: {
    type: String,
    required: false
  },
  email: {
    type: String,
    required: [true, 'Please add an email'],
    unique: true,
    match: [
      /^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$/,
      'Please add a valid email'
    ]
  },
  // 👇 添加这个新字段
  phone: {
    type: String,
    required: [true, 'Please add a phone number'],  // 必填
    match: [
      /^1[3-9]\d{9}$/,  // 简单的中国手机号验证：1开头，第二位3-9，总共11位
      'Please add a valid phone number'
    ]
  },
  // 👆 新字段结束
  role: {
    type: String,
    enum: ['admin', 'manager', 'analyst', 'client', 'president', 'secretary', 'treasurer', 'member'],
    default: 'member'
  },
  // ... 其余字段保持不变
});
```

### 步骤2：修改认证控制器 (`controllers/authController.js`)

在 `register` 函数中，添加对 `phone` 字段的处理：

```javascript
exports.register = async (req, res) => {
  try {
    // 👇 从请求体中解构出phone字段
    const { name, email, password, role, phone } = req.body;

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({
        success: false,
        error: 'User already exists'
      });
    }

    // 👇 在创建用户时包含phone字段
    const user = await User.create({
      name,
      email,
      password,
      role,
      phone  // 新增phone字段
    });

    sendTokenResponse(user, 200, res);
  } catch (err) {
    // ... 错误处理保持不变
  }
};
```

同时修改 `sendTokenResponse` 函数，在返回的用户信息中包含手机号：

```javascript
const sendTokenResponse = (user, statusCode, res) => {
  const token = user.getSignedJwtToken();

  res.status(statusCode).json({
    success: true,
    user: {
      id: user._id,
      name: user.name,
      email: user.email,
      role: user.role,
      phone: user.phone  // 👈 添加phone字段到响应中
    },
    token
  });
};
```

### 步骤3：修改APSEC路由 (`routes/apsec.js`)

如果你也想在APSEC特定的注册端点中添加手机号，需要修改所有的注册路由。以 `register-president` 为例：

```javascript
router.post('/register-president', async (req, res) => {
  try {
    // 👇 添加phone到解构中
    const { username, email, password, phone } = req.body;

    const user = await User.create({
      name: username || 'President User',
      username,
      email,
      password,
      role: 'president',
      phone  // 👈 新增phone字段
    });

    const token = user.getSignedJwtToken();

    res.status(200).json({
      success: true,
      token,
      user: {
        id: user._id,
        name: user.name,
        username: user.username,
        email: user.email,
        role: user.role,
        phone: user.phone  // 👈 响应中包含phone
      }
    });
  } catch (err) {
    res.status(400).json({
      success: false,
      error: err.message
    });
  }
});
```

**注意**：需要对所有4个APSEC注册路由做相同的修改：
- `/register-president`
- `/register-secretary`
- `/register-treasurer`
- `/register-member`

### 步骤4：更新默认用户（可选）

如果你想为默认用户也添加手机号，修改 `server.js` 中的 `createDefaultUsers` 函数：

```javascript
const createDefaultUsers = async () => {
  try {
    const users = [
      {
        name: 'Admin User',
        email: 'admin@techsecure.com',
        password: 'admin123',
        role: 'admin',
        phone: '13800138001'  // 👈 添加手机号
      },
      // ... 为其他默认用户也添加phone字段
    ];
    // ... 其余代码保持不变
  } catch (error) {
    console.error('Error creating default users:', error.message);
  }
};
```

## 🧪 测试新功能

### 1. 使用Postman测试注册

发送POST请求到 `http://localhost:5000/api/auth/register`：

```json
{
    "name": "测试用户",
    "email": "test@example.com",
    "password": "test123",
    "role": "client",
    "phone": "13812345678"  // 👈 新增的手机号字段
}
```

### 2. 预期响应

成功注册后应该返回：

```json
{
    "success": true,
    "user": {
        "id": "xxxxxxxxxxxxx",
        "name": "测试用户",
        "email": "test@example.com",
        "role": "client",
        "phone": "13812345678"  // 👈 响应中包含手机号
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI..."
}
```

### 3. 测试验证规则

尝试发送无效的手机号：

```json
{
    "name": "测试用户2",
    "email": "test2@example.com",
    "password": "test123",
    "role": "client",
    "phone": "123"  // 👈 无效的手机号
}
```

应该返回验证错误：

```json
{
    "success": false,
    "error": "User validation failed: phone: Please add a valid phone number"
}
```

## 🔍 验证数据库

使用MongoDB客户端或命令行工具查看数据库，确认新用户记录包含phone字段：

```bash
# MongoDB Shell命令
use auth-system
db.users.findOne({ email: "test@example.com" })
```

应该看到包含phone字段的用户文档：

```javascript
{
  "_id": ObjectId("..."),
  "name": "测试用户",
  "email": "test@example.com",
  "phone": "13812345678",  // 👈 新字段
  "role": "client",
  "password": "$2a$10$...",
  "createdAt": ISODate("..."),
  "__v": 0
}
```

## 💡 简化版本（如果不需要验证）

如果老师只要求添加字段而不需要验证，可以简化phone字段定义：

```javascript
// 在 models/User.js 中
phone: {
  type: String,
  required: false  // 可选字段
}
```

这样就不需要手机号格式验证，任何字符串都可以接受。

## 📝 总结

通过以上步骤，你已经成功地：

1. ✅ 在数据模型中添加了phone字段
2. ✅ 在控制器中处理phone数据
3. ✅ 在响应中返回phone信息
4. ✅ 添加了基本的手机号验证

## 🎯 额外练习

如果想进一步练习，可以尝试：

1. **添加手机号唯一性验证**：确保一个手机号只能注册一次
   ```javascript
   phone: {
     type: String,
     required: true,
     unique: true,  // 添加唯一性约束
     // ...
   }
   ```

2. **支持国际手机号**：修改正则表达式支持不同国家的手机号格式

3. **添加手机号更新功能**：创建一个新的API端点允许用户更新手机号

## ⚠️ 注意事项

1. **数据库迁移**：如果系统中已有用户数据，添加必填字段可能导致问题。可以先设置为可选字段，或为现有用户提供默认值。

2. **安全考虑**：在实际项目中，手机号是敏感信息，应该：
   - 在某些API响应中隐藏部分号码（如：138****5678）
   - 记录手机号修改日志
   - 实现手机号验证码功能

3. **错误处理**：确保添加适当的错误处理，特别是处理重复手机号的情况。

---

这就是添加手机号字段的完整指南！记住，**最简单的方法**就是：
1. 在模型中添加字段
2. 在控制器中处理数据
3. 测试功能是否正常

祝你完成作业顺利！ 🚀 