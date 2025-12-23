INSERT INTO "public"."articles" ("id", "title", "content", "directory_id", "is_published", "created_at", "updated_at") VALUES ('028fcc04-74b2-4765-9692-ef2461af4b86', 'React-Redux', 'Redux 本身是独立的状态管理库，与 React 无关——React-Redux 是官方提供的“桥梁库”，负责将 Redux Store 与 React 组件连接，实现组件对 Redux 状态的读取和修改。

# 1. 核心准备：Provider 全局注入 Store
要让所有 React 组件访问 Redux Store，需在应用根组件外层包裹 `Provider` 组件（从 `react-redux` 导入），并传入 Store 实例：

```javascript
// src/index.js
import React from ''react'';
import ReactDOM from ''react-dom/client'';
import { Provider } from ''react-redux'';
import store from ''./store'';
import App from ''./App'';

const root = ReactDOM.createRoot(document.getElementById(''root''));
root.render(
  // 包裹 Provider，注入 Store
  <Provider store={store}>
    <App />
  </Provider>
);
```

# 2. useSelector：读取 Redux 状态
`useSelector` 是 React-Redux 提供的 Hook，用于从 Redux Store 中提取需要的状态，并订阅状态变化——当对应状态更新时，组件会自动重新渲染。

## 2.1 语法
```javascript
import { useSelector } from ''react-redux'';

// 传入选择器函数（参数为全局 state，返回需要的状态）
const 状态变量 = useSelector((state) => state.模块名.具体属性);
```

## 2.2 关键注意事项
- 选择器函数需返回“组件需要的最小状态”（避免不必要的重渲染）；
- 默认使用“严格相等（===）”比较前后状态，若返回对象/数组（引用类型），需注意不可变（或使用 `shallowEqual` 浅比较）；
- 可多次调用 `useSelector` 提取不同状态。

## 2.3 示例
```javascript
import { useSelector } from ''react-redux'';

function TodoList() {
  // 提取 todos 状态（state.todos 对应 Store 中 todoSlice 的状态）
  const todos = useSelector((state) => state.todos.todos);
  // 提取用户登录状态
  const isLogin = useSelector((state) => state.user.isLogin);

  return (
    <div>
      {isLogin ? (
        <ul>
          {todos.map((todo) => (
            <li key={todo.id}>{todo.text}</li>
          ))}
        </ul>
      ) : (
        <p>请登录后查看待办</p>
      )}
    </div>
  );
}
```

## 2.4 浅比较优化（避免引用类型导致的重渲染）
若选择器返回对象/数组（如 `state.todos.filter(...)`），每次渲染会生成新引用，导致组件不必要重渲染，可使用 `shallowEqual` 作为第二个参数：

```javascript
import { useSelector, shallowEqual } from ''react-redux'';

// 提取已完成的待办（返回新数组）
const completedTodos = useSelector(
  (state) => state.todos.todos.filter(todo => todo.completed),
  shallowEqual // 浅比较：仅比较数组元素是否相同，而非引用
);
```

# 3. useDispatch：触发 Action 并修改状态
`useDispatch` 是 React-Redux 提供的 Hook，用于获取 Redux Store 的 `dispatch` 函数，通过调用 `dispatch(action)` 触发状态更新。

## 3.1 语法
```javascript
import { useDispatch } from ''react-redux'';
import { 动作创建函数 } from ''./features/xxxSlice'';

const dispatch = useDispatch();

// 触发 Action：dispatch(动作创建函数(参数))
dispatch(动作创建函数(数据));
```

## 3.2 示例
```javascript
import { useState } from ''react'';
import { useDispatch, useSelector } from ''react-redux'';
import { addTodo } from ''./features/todo/todoSlice'';

function AddTodoForm() {
  const [text, setText] = useState('''');
  const dispatch = useDispatch();
  const isLogin = useSelector((state) => state.user.isLogin);

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!text.trim() || !isLogin) return;

    // 触发 addTodo Action，携带 payload 数据
    dispatch(
      addTodo({
        id: Date.now(),
        text,
        completed: false
      })
    );

    setText(''''); // 清空输入框
  };

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="text"
        value={text}
        onChange={(e) => setText(e.target.value)}
        placeholder="请输入待办事项"
        disabled={!isLogin}
      />
      <button type="submit" disabled={!text.trim() || !isLogin}>
        添加待办
      </button>
    </form>
  );
}
```

# 4. 组件连接核心流程
1. 根组件用 `Provider` 注入 Store，让所有子组件可访问；
2. 组件内用 `useSelector` 读取需要的 Redux 状态；
3. 组件内用 `useDispatch` 获取 dispatch 函数，通过调用 Action 创建函数触发状态更新；
4. Redux Store 接收 Action 后，通过 Reducer 计算新状态；
5. `useSelector` 订阅的状态更新，组件自动重新渲染。', 'a3109983-f66b-42c0-afb5-8d07e97cbc4e', 'true', '2025-12-22 03:12:17.715894+00', '2025-12-23 08:38:24.169184+00'), ('04242d24-3e5d-4d42-8202-f65133cb9762', 'React Router 安装与核心组件', 'React Router 是 React 生态中最常用的路由解决方案，用于实现单页应用（SPA）的页面跳转与路由管理。其核心是通过组件化的方式定义路由规则，实现 URL 与组件的映射。以下是 React Router 的安装流程及三大核心组件的详细解析：

# 1. React Router 安装
React Router 分为 Web 端（`react-router-dom`）和原生端（`react-router-native`），Web 开发需安装 `react-router-dom`（当前稳定版本为 v6+，与 v5 有较大差异，以下内容基于 v6 版本）。

## 1.1 安装命令
```bash
npm 安装
npm install react-router-dom --save

yarn 安装
yarn add react-router-dom
```

## 1.2 环境配置验证
安装完成后，可在项目入口文件（如 `index.js`）中引入核心组件，验证是否安装成功：
```jsx
import { BrowserRouter } from ''react-router-dom'';
// 若未报错，则安装成功
```

# 2. 核心组件解析
React Router v6 的核心组件包括 `BrowserRouter`、`Routes`、`Route`，三者各司其职，共同构成路由系统的基础。

## 2.1 BrowserRouter：路由根容器
`BrowserRouter` 是所有路由组件的顶层容器，用于包裹整个应用的路由结构，提供路由上下文（如 URL 监听、路由状态管理）。

### 2.1.1 核心作用
- 监听浏览器 URL 变化，同步路由状态；
- 提供路由相关的上下文（通过 `useContext` 可在子组件中获取路由信息）；
- 支持 HTML5 的 History API（无 `#` 号的 URL 形式）。

### 2.1.2 使用方式
需在应用最顶层包裹（通常是 `App` 组件外层）：
```jsx
// index.js
import React from ''react'';
import ReactDOM from ''react-dom/client'';
import { BrowserRouter } from ''react-router-dom'';
import App from ''./App'';

const root = ReactDOM.createRoot(document.getElementById(''root''));
root.render(
  <BrowserRouter>
    <App /> {/* 所有路由相关组件需在 BrowserRouter 内部 */}
  </BrowserRouter>
);
```

### 2.1.3 注意事项
- 整个应用只能有一个 `BrowserRouter` 根容器，不可嵌套；
- 若部署到非根路径的服务器（如 `https://example.com/app/`），需配置 `basename` 属性：
  ```jsx
  <BrowserRouter basename="/app">
    {/* 路由路径会自动拼接 /app，如 /home → /app/home */}
  </BrowserRouter>
  ```

## 2.2 Routes：路由匹配容器
`Routes`（替代 v5 中的 `Switch`）是路由规则的容器，用于包裹多个 `Route` 组件，其核心作用是**匹配当前 URL 与路由规则，仅渲染第一个匹配成功的 `Route` 组件**。

### 2.2.1 核心特性
- 排他性匹配：仅渲染匹配成功的第一个 `Route`，避免多个路由同时渲染；
- 支持嵌套路由：可在子组件中再次使用 `Routes` 定义嵌套路由规则；
- 自动处理路由优先级：路径更具体的路由（如 `/user/:id`）会优先于模糊路由（如 `/user`）匹配。

### 2.2.2 使用方式
在 `BrowserRouter` 内部使用，包裹所有 `Route` 组件：
```jsx
// App.js
import { Routes, Route } from ''react-router-dom'';
import Home from ''./pages/Home'';
import About from ''./pages/About'';
import NotFound from ''./pages/NotFound'';

function App() {
  return (
    <div className="App">
      <Routes>
        {/* 定义路由规则：path 为 URL 路径，element 为匹配后渲染的组件 */}
        <Route path="/" element={<Home />} />
        <Route path="/about" element={<About />} />
        {/* 404 路由：path="*" 匹配所有未定义的路由 */}
        <Route path="*" element={<NotFound />} />
      </Routes>
    </div>
  );
}

export default App;
```

## 2.3 Route：路由规则组件
`Route` 是单个路由规则的定义，用于关联 URL 路径与组件，是路由系统的核心最小单元。

### 2.3.1 核心属性
| 属性名   | 类型          | 说明                                                                 |
|----------|---------------|----------------------------------------------------------------------|
| `path`   | string        | 路由路径（相对路径，基于父组件的 `path`），支持静态路径、动态路径、通配符 |
| `element`| ReactElement  | 路由匹配成功后渲染的组件（必须是 React 元素，如 `<Home />`，而非 `Home`） |
| `index`  | boolean       | 索引路由：当父路由路径匹配，但子路由无匹配时，渲染该索引组件（替代 `path=""`） |
| `children`| Route[]      | 嵌套路由的子路由规则                                                 |

### 2.3.2 常用用法
1. **静态路由**：路径固定的路由（最常用）
   ```jsx
   <Route path="/home" element={<Home />} />
   <Route path="/about/team" element={<Team />} /> {/* 多级静态路径 */}
   ```

2. **索引路由（index）**：父路由默认渲染的组件，无需额外路径
   ```jsx
   <Route path="/user" element={<UserLayout />}>
     {/* 当 URL 为 /user 时，渲染 UserProfile（索引组件） */}
     <Route index element={<UserProfile />} />
     <Route path="settings" element={<UserSettings />} /> {/* /user/settings */}
   </Route>
   ```

3. **通配符路由（404）**：`path="*"` 匹配所有未定义的路由，用于 404 页面
   ```jsx
   <Route path="*" element={<NotFound />} />
   ```

### 2.3.3 注意事项
- `element` 属性必须传入 React 元素（带 `<>`），不能传入组件函数（如 `element={Home}` 是错误的）；
- 路由路径默认是**相对路径**，若需绝对路径，可在路径前加 `/`（如 `/about` 是绝对路径，`about` 是相对父路由的路径）；
- `Routes` 内部的 `Route` 无需排序（v6 会自动按路径特异性排序），但通配符路由（`path="*"`）需放在最后。

# 3. 核心组件工作流程
1. `BrowserRouter` 初始化路由上下文，监听 URL 变化；
2. 当 URL 改变时，`Routes` 遍历所有子 `Route` 组件，匹配当前 URL；
3. 找到第一个匹配的 `Route`，渲染其 `element` 属性指定的组件；
4. 若未找到匹配的路由，渲染 `path="*"` 对应的 404 组件。

## 4. 常见问题与注意事项
1. **v6 与 v5 差异**：v6 移除了 `Switch`（替换为 `Routes`）、`Redirect`（替换为 `Navigate`），`Route` 的 `component` 属性替换为 `element`；
2. **路由组件必须在 BrowserRouter 内部**：所有使用 `Link`、`useNavigate` 等路由相关 API 的组件，必须包裹在 `BrowserRouter` 中，否则会报错；
3. **路径匹配规则**：v6 中路由路径匹配是“精确匹配”（无需 `exact` 属性），如 `/home` 仅匹配 `/home`，不匹配 `/home/123`（动态路由除外）。', 'aee449bc-0035-43a6-834d-3e6ce98b6aff', 'true', '2025-12-22 02:05:57.233923+00', '2025-12-23 02:36:30.475034+00'), ('04b2256d-0593-40ee-a70e-fd9117a36658', '路由跳转', '在 React Router v6 中，路由跳转主要通过三种方式实现：`Link` 组件（普通跳转）、`NavLink` 组件（带激活状态的跳转）、`useNavigate` 钩子（编程式跳转）。三者分别适用于不同场景，以下是详细解析：

# 1. Link 组件：普通路由跳转
`Link` 是 React Router 提供的基础跳转组件，用于在页面中创建可点击的跳转链接，本质是对原生 `<a>` 标签的封装，但不会触发页面刷新（单页应用核心特性）。

## 1.1 核心作用
- 实现无刷新跳转，保持 SPA 应用的状态；
- 生成与路由规则匹配的 URL，避免手动拼接路径；
- 支持相对路径和绝对路径跳转。

## 1.2 核心属性
| 属性名   | 类型          | 说明                                                                 |
|----------|---------------|----------------------------------------------------------------------|
| `to`     | string/object | 跳转目标路径，支持字符串（绝对/相对路径）或对象（复杂跳转配置）       |
| `replace` | boolean       | 若为 `true`，则使用 `history.replace` 跳转（不添加新历史记录，无法回退）；默认 `false`（添加历史记录） |

## 1.3 使用方式
### 1.3.1 字符串路径（最常用）
```jsx
import { Link } from ''react-router-dom'';

function Navbar() {
  return (
    <nav>
      {/* 绝对路径：从根路径开始 */}
      <Link to="/">首页</Link>
      <Link to="/about">关于我们</Link>
      
      {/* 相对路径：基于当前路由路径 */}
      {/* 若当前路径是 /user，则跳转后为 /user/settings */}
      <Link to="settings">用户设置</Link>
      {/* 若当前路径是 /user/settings，则跳转后为 /user */}
      <Link to="..">返回用户中心</Link>
    </nav>
  );
}
```

### 1.3.2 对象形式路径（复杂跳转）
当需要传递搜索参数、状态等信息时，可使用对象形式的 `to` 属性：
```jsx
<Link
  to={{
    pathname: ''/user'', // 目标路径
    search: ''?id=123'', // 搜索参数（query参数）
    state: { from: ''navbar'' } // 隐式状态（不会显示在URL中，通过useLocation获取）
  }}
>
  查看用户详情
</Link>
```

### 1.3.3 replace 模式跳转
```jsx
// 跳转后不会添加新历史记录，点击回退会回到上上个页面
<Link to="/login" replace>
  登录（不可回退）
</Link>
```

## 1.4 注意事项
- `Link` 组件必须在 `BrowserRouter` 内部使用，否则会报错；
- 避免在 `Link` 内部嵌套 `<a>` 标签，可能导致冲突；
- 相对路径的基准是当前路由的**路径部分**，而非文件目录结构。

# 2. NavLink 组件：带激活状态的跳转
`NavLink` 是 `Link` 组件的增强版，除了具备 `Link` 的所有功能外，还支持在路由匹配时自动添加激活状态（如高亮样式），适用于导航菜单、Tab 切换等场景。

## 2.1 核心特性
- 路由匹配时，自动为组件添加激活类名或样式；
- 支持自定义激活条件、激活类名、激活样式；
- 完全兼容 `Link` 的所有属性（`to`、`replace` 等）。

## 2.2 核心属性（新增属性）
| 属性名         | 类型          | 说明                                                                 |
|----------------|---------------|----------------------------------------------------------------------|
| `className`    | string/function | 静态类名，或接收 `isActive` 参数的函数（返回动态类名）               |
| `style`        | object/function | 静态样式，或接收 `isActive` 参数的函数（返回动态样式）               |
| `isActive`     | function      | 自定义激活判定函数，接收 `match` 和 `location` 参数，返回布尔值       |
| `caseSensitive`| boolean       | 是否大小写敏感匹配路径，默认 `false`                                 |

## 2.3 使用方式
### 2.3.1 基础激活样式（默认类名）
React Router v6 中，`NavLink` 匹配成功时默认添加 `active` 类名，可直接通过 CSS 样式控制高亮：
```jsx
// 组件代码
import { NavLink } from ''react-router-dom'';
import ''./Navbar.css'';

function Navbar() {
  return (
    <nav>
      <NavLink to="/">首页</NavLink>
      <NavLink to="/about">关于我们</NavLink>
      <NavLink to="/user">用户中心</NavLink>
    </nav>
  );
}

// Navbar.css
/* 匹配成功时的高亮样式 */
nav a.active {
  color: #1890ff;
  font-weight: bold;
  border-bottom: 2px solid #1890ff;
}
```

### 2.3.2 自定义激活类名
通过 `className` 函数自定义激活类名：
```jsx
<NavLink
  to="/about"
  // isActive 为布尔值，true 表示当前路由匹配
  className={(isActive) => (isActive ? ''nav-active'' : ''nav-normal'')}
>
  关于我们
</NavLink>

// CSS
.nav-active {
  color: red;
  background: #f5f5f5;
}
.nav-normal {
  color: #333;
}
```

### 2.3.3 自定义激活样式
通过 `style` 函数直接设置激活样式：
```jsx
<NavLink
  to="/user"
  style={(isActive) => ({
    color: isActive ? ''#1890ff'' : ''#666'',
    padding: ''8px 16px'',
    textDecoration: ''none'',
  })}
>
  用户中心
</NavLink>
```

### 2.3.4 自定义激活判定逻辑
通过 `isActive` 函数控制激活条件（适用于复杂路由匹配）：
```jsx
// 当路径包含 /user 时（如 /user、/user/settings），均视为激活
<NavLink
  to="/user"
  isActive={(match) => {
    if (!match) return false;
    // match.pathname 为当前匹配的路径
    return match.pathname.startsWith(''/user'');
  }}
>
  用户中心（包含子路由激活）
</NavLink>
```

# 3. useNavigate 钩子：编程式跳转
`useNavigate` 是 React Router v6 提供的钩子函数，用于在组件逻辑中（如按钮点击、请求成功后）触发路由跳转，支持更灵活的编程式控制（替代 v5 中的 `useHistory`）。

## 3.1 核心作用
- 在函数组件中通过代码触发跳转（无需手动操作 DOM）；
- 支持前进、后退、替换历史记录等操作；
- 可传递搜索参数、状态信息。

## 3.2 基本用法
### 3.2.1 导入与初始化
```jsx
import { useNavigate } from ''react-router-dom'';

function LoginButton() {
  // 初始化 navigate 函数
  const navigate = useNavigate();

  const handleLogin = () => {
    // 模拟登录成功
    const loginSuccess = true;
    if (loginSuccess) {
      // 跳转至首页
      navigate(''/'');
    }
  };

  return <button onClick={handleLogin}>登录</button>;
}
```

### 3.2.2 核心跳转 API
```jsx
const navigate = useNavigate();

// 1. 基础跳转（添加历史记录，可回退）
navigate(''/about''); // 绝对路径
navigate(''settings''); // 相对路径（基于当前路由）

// 2. 替换历史记录（不可回退）
navigate(''/login'', { replace: true });

// 3. 前进/后退（类似浏览器的前进后退按钮）
navigate(-1); // 后退一页
navigate(1); // 前进一页
navigate(-2); // 后退两页

// 4. 传递状态（隐式参数，不会显示在URL中）
navigate(''/user'', {
  state: { from: ''login'', userId: 123 } // 状态数据
});

// 5. 传递搜索参数（显式参数，URL中可见）
navigate(''/user?id=123&name=张三'');
// 或通过 URLSearchParams 拼接
const params = new URLSearchParams({ id: 123, name: ''张三'' });
navigate(`/user?${params}`);
```

### 3.2.3 结合异步操作跳转
```jsx
function UserForm() {
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      // 模拟提交表单请求
      await fetch(''/api/submit'', { method: ''POST'', body: JSON.stringify(formData) });
      // 请求成功后跳转至结果页，并传递状态
      navigate(''/submit-success'', {
        state: { message: ''提交成功！'' },
        replace: true // 避免回退到表单页
      });
    } catch (error) {
      console.error(''提交失败：'', error);
    }
  };

  return <form onSubmit={handleSubmit}>{/* 表单内容 */}</form>;
}
```

## 3.3 注意事项
- `useNavigate` 只能在函数组件或自定义 Hooks 中使用，不能在类组件或普通函数中调用；
- 传递的 `state` 数据会存储在浏览器的历史记录中，刷新页面后会丢失（若需持久化，需使用本地存储或后端存储）；
- 相对路径跳转的基准是当前路由的路径，而非文件目录，若需跳转到根路径，需使用绝对路径（如 `/home`）。

# 4. 三种跳转方式对比与场景选择
| 跳转方式   | 核心优势                  | 适用场景                                  |
|------------|---------------------------|-------------------------------------------|
| `Link`     | 简单易用，无额外逻辑      | 页面中静态跳转链接（如导航栏、文本链接）  |
| `NavLink`  | 自带激活状态，支持样式控制 | 导航菜单、Tab 切换、需要高亮当前页的场景  |
| `useNavigate` | 编程式控制，支持异步跳转  | 按钮点击、表单提交、请求成功后等动态场景  |

# 5. 常见问题与解决方案
1. **跳转后页面不刷新**：SPA 特性，路由跳转仅替换组件内容，不会刷新整个页面，若需刷新数据，可在组件的 `useEffect` 中监听路由变化；
2. **`state` 数据丢失**：`state` 存储在内存中的历史记录，刷新页面后丢失，解决方案：
   - 重要数据通过搜索参数传递（URL 可见）；
   - 非敏感数据使用 `localStorage` 持久化；
3. **相对路径跳转错误**：确保相对路径的基准是当前路由的路径，而非文件目录，可通过 `useLocation` 钩子获取当前路径，辅助调试：
   ```jsx
   import { useLocation } from ''react-router-dom'';
   const location = useLocation();
   console.log(''当前路径：'', location.pathname); // 查看当前路径，辅助拼接相对路径
   ```', 'aee449bc-0035-43a6-834d-3e6ce98b6aff', 'true', '2025-12-22 02:06:18.567992+00', '2025-12-23 02:40:11.081143+00'), ('0753cad5-fccc-4a27-8085-ed21e72b1a3b', 'React Hook Form 入门', '# 1. React Hook Form 核心优势
React Hook Form（RHF）是一款轻量级、高性能的 React 表单库，核心设计理念是“非受控表单 + 原生验证”，相比传统受控表单方案，具有以下优势：
- **性能优异**：减少不必要的组件重渲染（仅追踪需要验证的字段）；
- **体积小巧**：核心包体积约 10KB（gzip 后），无冗余依赖；
- **易用性高**：基于 Hooks 设计，API 简洁直观；
- **原生兼容**：支持原生 HTML 表单验证，可与第三方 UI 库无缝集成；
- **扩展性强**：支持自定义验证、表单嵌套、异步验证等复杂场景。

# 2. 基础安装与配置
```bash
npm install react-hook-form

yarn add react-hook-form
```

# 3. 核心 API 详解
## 3.1 useForm：初始化表单
`useForm` 是 RHF 的核心 Hook，用于初始化表单实例，返回一系列操作表单的方法和状态。

**基础用法**：
```javascript
import { useForm } from ''react-hook-form'';

function BasicForm() {
  // 初始化表单实例
  const {
    register, // 注册表单字段
    handleSubmit, // 处理表单提交
    formState: { errors } // 表单状态（错误信息）
  } = useForm();

  // 提交成功回调
  const onSubmit = (data) => {
    console.log(''表单数据：'', data);
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      {/* 注册表单字段 */}
      <div>
        <label>用户名：</label>
        <input {...register(''username'')} placeholder="请输入用户名" />
      </div>
      <button type="submit">提交</button>
    </form>
  );
}
```

**useForm 配置项**：
```javascript
const { register, handleSubmit } = useForm({
  mode: ''onSubmit'', // 验证时机：onSubmit（默认）/onChange/onBlur/onTouched
  defaultValues: { // 表单默认值
    username: '''',
    password: ''''
  },
  reValidateMode: ''onChange'', // 重新验证时机
  shouldFocusError: true, // 提交时自动聚焦到第一个错误字段
  criteriaMode: ''firstError'' // 错误展示模式：firstError（默认）/allErrors
});
```

## 3.2 register：注册表单字段
`register` 用于将表单元素与 RHF 实例关联，支持配置验证规则、默认值等。

**语法**：
```javascript
register(name, options)
```

**参数说明**：
- `name`：字段名（支持嵌套，如 `user.name`）；
- `options`：验证规则配置（可选）。

**基础验证规则示例**：
```javascript
import { useForm } from ''react-hook-form'';

function RegisterForm() {
  const { register, handleSubmit, formState: { errors } } = useForm();

  const onSubmit = (data) => console.log(data);

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      {/* 用户名：必填 + 长度 3-10 位 */}
      <div>
        <label>用户名：</label>
        <input
          {...register(''username'', {
            required: ''用户名不能为空'', // 必填验证（自定义错误信息）
            minLength: {
              value: 3,
              message: ''用户名长度不能少于 3 位''
            },
            maxLength: {
              value: 10,
              message: ''用户名长度不能超过 10 位''
            }
          })}
          placeholder="请输入用户名"
        />
        {/* 显示错误信息 */}
        {errors.username && <span style={{ color: ''red'' }}>{errors.username.message}</span>}
      </div>

      {/* 密码：必填 + 最小长度 6 位 */}
      <div>
        <label>密码：</label>
        <input
          type="password"
          {...register(''password'', {
            required: ''密码不能为空'',
            minLength: { value: 6, message: ''密码长度不能少于 6 位'' }
          })}
          placeholder="请输入密码"
        />
        {errors.password && <span style={{ color: ''red'' }}>{errors.password.message}</span>}
      </div>

      <button type="submit">提交</button>
    </form>
  );
}
```

## 3.3 handleSubmit：处理表单提交
`handleSubmit` 用于包装提交回调函数，自动触发表单验证：
- 验证通过：执行 `onSubmit` 回调，传入表单数据；
- 验证失败：不执行 `onSubmit`，更新 `errors` 状态。

**支持错误回调**：
```javascript
const onSubmit = (data) => console.log(''成功：'', data);
const onError = (errors) => console.log(''失败：'', errors);

<form onSubmit={handleSubmit(onSubmit, onError)}>
  {/* 表单内容 */}
</form>
```

# 4. 常用验证规则
RHF 支持丰富的内置验证规则，也支持自定义验证函数：

| 规则 | 说明 | 示例 |
|------|------|------|
| `required` | 必填项 | `required: ''字段不能为空''` |
| `minLength` | 最小长度 | `minLength: { value: 3, message: ''长度≥3'' }` |
| `maxLength` | 最大长度 | `maxLength: { value: 10, message: ''长度≤10'' }` |
| `min` | 最小值（数值） | `min: { value: 18, message: ''≥18'' }` |
| `max` | 最大值（数值） | `max: { value: 60, message: ''≤60'' }` |
| `pattern` | 正则匹配 | `pattern: { value: /^1[3-9]\d{9}$/, message: ''手机号格式错误'' }` |
| `validate` | 自定义验证 | `validate: (value) => value !== ''admin'' || ''不能为admin''` |

## 自定义验证示例（异步验证）：
```javascript
<input
  {...register(''email'', {
    required: ''邮箱不能为空'',
    pattern: {
      value: /^[\w.-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$/,
      message: ''邮箱格式错误''
    },
    // 异步验证：检查邮箱是否已注册
    validate: async (value) => {
      const res = await fetch(`/api/check-email?email=${value}`);
      const data = await res.json();
      return data.available || ''该邮箱已被注册'';
    }
  })}
/>
```

# 5. 高级用法
## 5.1 嵌套字段（复杂表单）
支持嵌套字段名（如 `user.name`、`user.address.city`），表单数据会自动生成嵌套对象：
```javascript
function NestedForm() {
  const { register, handleSubmit, formState: { errors } } = useForm({
    defaultValues: {
      user: {
        name: '''',
        email: ''''
      },
      address: {
        city: '''',
        street: ''''
      }
    }
  });

  const onSubmit = (data) => {
    console.log(data);
    // 输出：{ user: { name: '''', email: '''' }, address: { city: '''', street: '''' } }
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <div>
        <label>姓名：</label>
        <input {...register(''user.name'', { required: ''姓名不能为空'' })} />
        {errors.user?.name && <span style={{ color: ''red'' }}>{errors.user.name.message}</span>}
      </div>
      <div>
        <label>邮箱：</label>
        <input {...register(''user.email'', { required: ''邮箱不能为空'' })} />
        {errors.user?.email && <span style={{ color: ''red'' }}>{errors.user.email.message}</span>}
      </div>
      <div>
        <label>城市：</label>
        <input {...register(''address.city'', { required: ''城市不能为空'' })} />
        {errors.address?.city && <span style={{ color: ''red'' }}>{errors.address.city.message}</span>}
      </div>
      <button type="submit">提交</button>
    </form>
  );
}
```

## 5.2 表单重置与setValue
- `reset`：重置表单到默认值（或指定值）；
- `setValue`：手动设置单个字段值。

```javascript
import { useForm } from ''react-hook-form'';

function ResetForm() {
  const { register, handleSubmit, reset, setValue } = useForm({
    defaultValues: { username: '''' }
  });

  const onSubmit = (data) => console.log(data);

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <input {...register(''username'')} placeholder="用户名" />
      <button type="submit">提交</button>
      <button type="button" onClick={() => reset()}>重置默认值</button>
      <button type="button" onClick={() => reset({ username: ''默认用户名'' })}>重置为指定值</button>
      <button type="button" onClick={() => setValue(''username'', ''手动设置值'')}>手动设置值</button>
    </form>
  );
}
```

## 5.3 与 UI 库集成（以 Ant Design 为例）
RHF 可与 Ant Design、Material UI 等组件库无缝集成，通过 `register` 绑定组件的 `onChange` 和 `value`：
```javascript
import { useForm } from ''react-hook-form'';
import { Input, Button, Form, message } from ''antd'';

function AntdForm() {
  const { register, handleSubmit, formState: { errors } } = useForm();

  const onSubmit = (data) => {
    message.success(''提交成功'');
    console.log(data);
  };

  return (
    <Form onFinish={handleSubmit(onSubmit)}>
      <Form.Item
        label="用户名"
        validateStatus={errors.username ? ''error'' : ''''}
        help={errors.username?.message}
      >
        <Input
          placeholder="请输入用户名"
          {...register(''username'', {
            required: ''用户名不能为空'',
            minLength: { value: 3, message: ''用户名长度≥3'' }
          })}
        />
      </Form.Item>
      <Form.Item
        label="密码"
        validateStatus={errors.password ? ''error'' : ''''}
        help={errors.password?.message}
      >
        <Input.Password
          placeholder="请输入密码"
          {...register(''password'', {
            required: ''密码不能为空'',
            minLength: { value: 6, message: ''密码长度≥6'' }
          })}
        />
      </Form.Item>
      <Form.Item>
        <Button type="primary" htmlType="submit">提交</Button>
      </Form.Item>
    </Form>
  );
}
```

# 6. 性能优化
- **减少重渲染**：使用 `useForm` 的 `shouldUnregister` 配置（默认 `true`），卸载组件时自动注销字段，避免无效渲染；
- **延迟验证**：通过 `mode: ''onBlur''` 或 `mode: ''onSubmit''` 减少实时验证的性能开销；
- **批量更新**：使用 `batch` 方法批量更新表单状态，避免多次重渲染。', 'fa2521c5-ab87-4500-9375-449364eb3b13', 'true', '2025-12-22 03:19:01.863528+00', '2025-12-23 13:10:57.109815+00'), ('0cb041b2-afd7-4c00-a4f3-c73502ccfa50', 'React 单元测试', '# 1. 测试核心概念与工具选型
## 1.1 单元测试的价值
React 项目中单元测试聚焦于最小可测试单元（组件、函数、Hook），核心价值：
- 验证代码功能正确性，减少回归 bug；
- 提升代码可维护性（测试用例即文档）；
- 支持重构信心（重构后测试通过即功能稳定）。

## 1.2 主流测试工具组合
- **Jest**：Facebook 开发的测试运行器，提供测试框架、断言库、模拟（Mock）功能、覆盖率统计；
- **React Testing Library**：轻量级测试库，强调“用户行为驱动测试”（而非测试实现细节），与 Jest 无缝集成；
- 替代方案：Enzyme（更关注组件内部实现，维护频率降低，逐渐被 React Testing Library 取代）。

# 2. 环境搭建
## 2.1 新建项目（内置测试环境）
- **Create React App（CRA）**：默认内置 Jest + React Testing Library，无需额外配置：
  ```bash
  npx create-react-app my-test-app --template typescript # TypeScript 项目
  ```
- **Vite 项目**：需手动安装依赖：
  ```bash
  npm install -D jest @testing-library/react @testing-library/jest-dom @testing-library/user-event jsdom @types/jest ts-jest # TypeScript 项目
  ```
  配置 `jest.config.js`：
  ```javascript
  export default {
    testEnvironment: ''jsdom'', // 模拟浏览器环境
    transform: {
      ''^.+\\.(ts|tsx)$'': ''ts-jest'', // 处理 TypeScript
    },
    moduleFileExtensions: [''ts'', ''tsx'', ''js'', ''jsx''],
    setupFilesAfterEnv: [''<rootDir>/src/setupTests.ts''], // 全局配置
  };
  ```
  创建 `src/setupTests.ts`（扩展匹配器）：
  ```typescript
  import ''@testing-library/jest-dom''; // 提供额外断言（如 toBeInTheDocument）
  ```

## 2.2 已有项目集成
```bash
npm install -D jest @testing-library/react @testing-library/jest-dom @testing-library/user-event

npm install -D @types/jest ts-jest

npm install -D jsdom
```

# 3. 核心 API 详解
## 3.1 React Testing Library 核心 API
| API 名称               | 作用                                                                 |
|------------------------|----------------------------------------------------------------------|
| `render(component)`    | 渲染 React 组件到测试 DOM 中，返回查询方法（getBy*、queryBy* 等）|
| `screen`               | 全局查询对象，替代 render 返回的查询方法（推荐使用）|
| `fireEvent`            | 触发 DOM 事件（如 click、change）|
| `userEvent`            | 模拟真实用户行为（更贴近真实操作，如 type、click，推荐替代 fireEvent） |
| `waitFor`              | 等待异步操作完成（如接口请求、状态更新）|
| `act()`                | 包裹 React 渲染/更新逻辑（React Testing Library 已自动封装，无需手动调用） |

## 3.2 查询方法分类（优先级从高到低）
React Testing Library 推荐按“用户可感知”的方式查询元素，而非 DOM 结构：
1. **getByRole**：按 ARIA 角色查询（最推荐，符合无障碍设计）
   ```tsx
   screen.getByRole(''button'', { name: /提交/i }); // 查询名称包含“提交”的按钮
   ```
2. **getByLabelText**：按表单标签文本查询（适用于输入框）
   ```tsx
   screen.getByLabelText(/用户名/i); // 查询标签为“用户名”的输入框
   ```
3. **getByPlaceholderText**：按占位符文本查询
   ```tsx
   screen.getByPlaceholderText(/请输入密码/i);
   ```
4. **getByText**：按文本内容查询
   ```tsx
   screen.getByText(/登录成功/i);
   ```
5. **getByTestId**：按自定义测试 ID 查询（万不得已时使用，需给元素加 `data-testid` 属性）
   ```tsx
   // 组件中：<div data-testid="user-card">...</div>
   screen.getByTestId(''user-card'');
   ```

**查询方法后缀差异**：
- `getBy*`：立即查询，找不到元素抛出错误（适用于元素肯定存在的场景）；
- `queryBy*`：立即查询，找不到元素返回 `null`（适用于元素可能不存在的场景）；
- `findBy*`：异步查询（返回 Promise），等待元素出现（适用于异步渲染的元素，如接口请求后显示）。

## 3.3 Jest 核心功能
- **断言**：使用 Jest 内置断言库验证结果：
  ```tsx
  expect(screen.getByText(/hello/i)).toBeInTheDocument(); // 元素存在
  expect(screen.queryByText(/error/i)).not.toBeInTheDocument(); // 元素不存在
  expect(input).toHaveValue(''test''); // 输入框值为 test
  ```
- **Mock 函数**：模拟函数并验证调用：
  ```tsx
  const mockClick = jest.fn();
  render(<Button onClick={mockClick}>点击</Button>);
  userEvent.click(screen.getByRole(''button''));
  expect(mockClick).toHaveBeenCalledTimes(1); // 被调用 1 次
  ```
- **覆盖率统计**：
  ```bash
  npm test -- --coverage # 生成覆盖率报告
  ```

# 4. 基础测试示例
## 4.1 组件渲染测试
测试组件是否正常渲染核心内容：
```tsx
// Button.tsx
import React from ''react'';

interface ButtonProps {
  children: React.ReactNode;
  onClick?: () => void;
}

const Button = ({ children, onClick }: ButtonProps) => {
  return <button onClick={onClick}>{children}</button>;
};

export default Button;

// Button.test.tsx
import React from ''react'';
import { screen, render } from ''@testing-library/react'';
import userEvent from ''@testing-library/user-event'';
import Button from ''./Button'';

test(''Button 渲染正确的文本'', () => {
  // 渲染组件
  render(<Button>提交</Button>);
  // 验证文本存在
  const button = screen.getByRole(''button'', { name: /提交/i });
  expect(button).toBeInTheDocument();
});

test(''Button 点击触发回调'', async () => {
  const user = userEvent.setup(); // 初始化 userEvent
  const mockClick = jest.fn();
  render(<Button onClick={mockClick}>提交</Button>);
  // 模拟用户点击
  await user.click(screen.getByRole(''button'', { name: /提交/i }));
  // 验证回调被调用
  expect(mockClick).toHaveBeenCalledTimes(1);
});
```

## 4.2 自定义 Hook 测试
使用 `@testing-library/react-hooks` 测试自定义 Hook（需安装依赖：`npm install -D @testing-library/react-hooks`）：
```tsx
// useCounter.ts
import { useState } from ''react'';

const useCounter = (initialValue = 0) => {
  const [count, setCount] = useState(initialValue);
  const increment = () => setCount(count + 1);
  const decrement = () => setCount(count - 1);
  return { count, increment, decrement };
};

export default useCounter;

// useCounter.test.ts
import { renderHook, act } from ''@testing-library/react-hooks'';
import useCounter from ''./useCounter'';

test(''useCounter 初始化值正确'', () => {
  const { result } = renderHook(() => useCounter(5));
  expect(result.current.count).toBe(5);
});

test(''increment 方法增加计数'', () => {
  const { result } = renderHook(() => useCounter());
  act(() => {
    result.current.increment();
  });
  expect(result.current.count).toBe(1);
});
```

# 5. 测试最佳实践
1. **测试用户行为，而非实现细节**：
   - 坏：测试组件内部状态变量（如 `expect(component.state.count).toBe(1)`）；
   - 好：测试用户可见的结果（如 `expect(screen.getByText(''Count: 1'')).toBeInTheDocument()`）。
2. **使用 `screen` 全局查询**：避免依赖 render 返回的查询对象，简化代码。
3. **优先使用 `userEvent` 而非 `fireEvent`**：`userEvent` 模拟真实用户行为（如输入时触发 focus/change 事件），更贴近实际场景。
4. **异步测试使用 `waitFor`/`findBy*`**：处理接口请求、定时器等异步逻辑。
5. **避免测试第三方组件**：聚焦于自己编写的业务代码。', 'a563f346-3dac-4331-b926-8587cb32b144', 'true', '2025-12-22 03:20:23.998591+00', '2025-12-23 13:43:12.068041+00'), ('0f7107cf-5ab8-4ebd-8e82-871bde498644', 'React 项目打包优化', '# 1. 打包优化核心目标
- 减小打包体积（减少加载时间、降低带宽消耗）；
- 提升加载速度（按需加载、缓存优化、CDN 加速）；
- 优化构建效率（缩短打包时间）。

# 2. Tree Shaking（摇树优化）
## 2.1 核心原理
Tree Shaking 是基于 ES 模块（`import`/`export`）的静态分析技术，移除代码中未被使用的部分（死代码），核心依赖：
- 模块必须是 ES 模块（CommonJS 模块 `require` 为动态导入，无法静态分析）；
- 打包工具（Webpack/Rollup）识别未使用的导出并删除；
- 代码压缩工具（Terser）移除死代码。

## 2.2 启用条件
1. **确保模块为 ES 模块**：
   - 项目代码使用 `import`/`export`（避免 `require`）；
   - 第三方库优先选择 ES 模块版本（查看 `package.json` 中的 `module` 字段）；
   - Webpack 中设置 `mode: ''production''`（自动启用 Tree Shaking）。

2. **避免破坏 Tree Shaking 的写法**：
   - 不使用 `import * as xxx` 导入所有模块（无法静态分析）；
   - 不将导出赋值给变量后使用（如 `const func = xxx; func()`）；
   - 避免副作用（如导入时执行代码的模块，需在 `package.json` 中标记 `sideEffects`）。

3. **标记副作用（sideEffects）**：
   在 `package.json` 中声明无副作用的文件，让 Webpack 放心删除未使用代码：
   ```json
   {
     "sideEffects": [
       "*.css", // CSS 文件有副作用（导入即生效）
       "*.scss",
       "src/global.js" // 全局代码有副作用
     ]
   }
   ```
   若项目无副作用文件，可设为 `"sideEffects": false`。

## 2.3 实战配置
### 2.3.1 Webpack 配置
```javascript
// webpack.config.js
module.exports = {
  mode: ''production'', // 生产模式自动启用 Tree Shaking
  optimization: {
    usedExports: true, // 标记未使用的导出
    sideEffects: true, // 启用副作用分析
  },
  resolve: {
    extensions: [''.tsx'', ''.ts'', ''.js''],
    mainFields: [''module'', ''main''], // 优先加载 ES 模块版本
  },
};
```

### 2.3.2 Vite 配置（天然支持 Tree Shaking）
Vite 生产环境基于 Rollup 构建，默认启用 Tree Shaking，无需额外配置，只需确保：
- 项目使用 ES 模块；
- 第三方库提供 ES 模块版本；
- 标记 `sideEffects`（同 Webpack）。

## 2.4 验证 Tree Shaking 效果
- 使用 `webpack-bundle-analyzer` 分析打包体积：
  ```bash
  npm install -D webpack-bundle-analyzer
  ```
  ```javascript
  // webpack.config.js
  const BundleAnalyzerPlugin = require(''webpack-bundle-analyzer'').BundleAnalyzerPlugin;
  module.exports = {
    plugins: [new BundleAnalyzerPlugin()], // 打包后自动打开分析页面
  };
  ```
- 查看分析报告中是否存在未使用的代码块，确认体积是否减小。

# 3. 代码/资源压缩
## 3.1 JS 压缩
- **Webpack**：生产模式默认使用 `TerserPlugin` 压缩 JS，可自定义配置：
  ```javascript
  // webpack.config.js
  const TerserPlugin = require(''terser-webpack-plugin'');
  module.exports = {
    optimization: {
      minimizer: [
        new TerserPlugin({
          parallel: true, // 多线程压缩（提升速度）
          terserOptions: {
            compress: {
              drop_console: true, // 生产环境移除 console
              drop_debugger: true, // 移除 debugger
              pure_funcs: [''console.log''], // 移除指定函数调用
            },
            mangle: true, // 混淆变量名
            keep_classnames: false, // 不保留类名
            keep_fnames: false, // 不保留函数名
          },
        }),
      ],
    },
  };
  ```
- **Vite**：默认使用 Esbuild 压缩 JS（比 Terser 快 20-40 倍），如需更深度压缩可切换为 Terser：
  ```javascript
  // vite.config.js
  import { defineConfig } from ''vite'';
  export default defineConfig({
    build: {
      minify: ''terser'', // 默认为 ''esbuild''
      terserOptions: {
        compress: {
          drop_console: true,
        },
      },
    },
  });
  ```

## 3.2 CSS 压缩
- **Webpack**：使用 `css-minimizer-webpack-plugin` 压缩 CSS：
  ```bash
  npm install -D css-minimizer-webpack-plugin
  ```
  ```javascript
  // webpack.config.js
  const CssMinimizerPlugin = require(''css-minimizer-webpack-plugin'');
  module.exports = {
    optimization: {
      minimizer: [new CssMinimizerPlugin()], // 压缩 CSS
    },
    module: {
      rules: [
        {
          test: /\.css$/,
          use: [MiniCssExtractPlugin.loader, ''css-loader''], // 提取 CSS 为单独文件
        },
      ],
    },
    plugins: [new MiniCssExtractPlugin({ filename: ''css/[name].[contenthash].css'' })],
  };
  ```
- **Vite**：默认压缩 CSS（使用 Esbuild），无需额外配置：
  ```javascript
  // vite.config.js
  export default defineConfig({
    build: {
      cssMinify: true, // 默认为 true
    },
  });
  ```

## 3.3 图片/资源压缩
- **Webpack**：使用 `image-webpack-loader` 压缩图片：
  ```bash
  npm install -D image-webpack-loader
  ```
  ```javascript
  // webpack.config.js
  module.exports = {
    module: {
      rules: [
        {
          test: /\.(png|jpe?g|gif|svg)$/i,
          use: [
            { loader: ''file-loader'' },
            {
              loader: ''image-webpack-loader'',
              options: {
                mozjpeg: { quality: 80 }, // JPEG 压缩质量
                optipng: { enabled: false }, // 禁用 OptiPNG
                pngquant: { quality: [0.6, 0.8] }, // PNG 压缩质量范围
              },
            },
          ],
        },
      ],
    },
  };
  ```
- **Vite**：使用 `vite-plugin-imagemin` 压缩图片：
  ```bash
  npm install -D vite-plugin-imagemin
  ```
  ```javascript
  // vite.config.js
  import viteImagemin from ''vite-plugin-imagemin'';
  export default defineConfig({
    plugins: [
      viteImagemin({
        gifsicle: { optimizationLevel: 3 },
        optipng: { optimizationLevel: 2 },
        mozjpeg: { quality: 80 },
        pngquant: { quality: [0.6, 0.8] },
      }),
    ],
  });
  ```

# 4. CDN 加速与外部化依赖
## 4.1 核心原理
将体积大的第三方依赖（如 React、ReactDOM、Antd）通过 CDN 引入，不打包到项目中，减少打包体积，利用 CDN 边缘节点加速加载。

## 4.2 实战配置
### 4.2.1 Webpack 外部化依赖（externals）
```javascript
// webpack.config.js
module.exports = {
  externals: {
    react: ''React'', // 全局变量 React 对应 import React from ''react''
    ''react-dom'': ''ReactDOM'', // 全局变量 ReactDOM 对应 import ReactDOM from ''react-dom''
    antd: ''antd'', // 全局变量 antd 对应 import antd from ''antd''
  },
};
```

在 `public/index.html` 中引入 CDN 资源：
```html
<!-- React & ReactDOM -->
<script src="https://cdn.jsdelivr.net/npm/react@18.2.0/umd/react.production.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/react-dom@18.2.0/umd/react-dom.production.min.js"></script>
<!-- Antd -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/antd@5.12.2/dist/antd.min.css" />
<script src="https://cdn.jsdelivr.net/npm/antd@5.12.2/dist/antd.min.js"></script>
```

### 4.2.2 Vite 外部化依赖（build.rollupOptions.external）
```javascript
// vite.config.js
export default defineConfig({
  build: {
    rollupOptions: {
      external: [''react'', ''react-dom'', ''antd''], // 外部化依赖
      output: {
        globals: {
          react: ''React'',
          ''react-dom'': ''ReactDOM'',
          antd: ''antd'',
        },
      },
    },
  },
});
```

在 `index.html` 中引入 CDN 资源（同 Webpack）。

## 4.3 注意事项
- 选择稳定的 CDN 服务商（如 jsDelivr、UNPKG、cdnjs）；
- 锁定依赖版本（避免 CDN 资源更新导致兼容性问题）；
- 考虑回退方案（CDN 加载失败时使用本地资源）：
  ```html
  <script src="https://cdn.jsdelivr.net/npm/react@18.2.0/umd/react.production.min.js"></script>
  <script>
    window.React || document.write(''<script src="/js/react.production.min.js"><\/script>'');
  </script>
  ```

# 5. 其他优化手段
## 5.1 代码分割（Code Splitting）
- **路由懒加载**（React Router）：
  ```tsx
  import { lazy, Suspense } from ''react'';
  import { BrowserRouter, Routes, Route } from ''react-router-dom'';

  // 懒加载组件
  const Home = lazy(() => import(''./pages/Home''));
  const About = lazy(() => import(''./pages/About''));

  function App() {
    return (
      <BrowserRouter>
        <Suspense fallback={<div>Loading...</div>}>
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/about" element={<About />} />
          </Routes>
        </Suspense>
      </BrowserRouter>
    );
  }
  ```
- **Webpack 手动分割代码**：
  ```javascript
  // webpack.config.js
  module.exports = {
    optimization: {
      splitChunks: {
        chunks: ''all'', // 分割所有模块（同步 + 异步）
        cacheGroups: {
          vendors: {
            test: /[\\/]node_modules[\\/]/,
            name: ''vendors'', // 第三方依赖打包为 vendors.js
            priority: -10,
          },
          common: {
            name: ''common'', // 公共代码打包为 common.js
            minChunks: 2,
            priority: -20,
          },
        },
      },
    },
  };
  ```

## 5.2 缓存优化
- 静态资源添加哈希（`[contenthash]`）：确保文件内容不变时哈希不变，利用浏览器缓存；
  ```javascript
  // Webpack
  output: {
    filename: ''js/[name].[contenthash].js'',
    chunkFilename: ''js/[name].[contenthash].chunk.js'',
  },
  // Vite
  build: {
    rollupOptions: {
      output: {
        entryFileNames: ''js/[name].[contenthash].js'',
        chunkFileNames: ''js/[name].[contenthash].js'',
        assetFileNames: ''[ext]/[name].[contenthash].[ext]'',
      },
    },
  },
  ```
- 配置服务器缓存策略（Nginx）：对哈希资源设置长期缓存，对 `index.html` 设置不缓存。

## 5.3 预加载/预获取
- **预加载（preload）**：提前加载当前页面需要的资源；
- **预获取（prefetch）**：空闲时加载未来可能需要的资源（如路由懒加载组件）；
  ```tsx
  // React Router 预获取
  const About = lazy(() => import(/* webpackPrefetch: true */ ''./pages/About''));
  ```

# 6. 打包体积分析工具
- **Webpack**：`webpack-bundle-analyzer`（可视化打包内容）；
- **Vite**：`rollup-plugin-visualizer`（Vite 内置支持）：
  ```javascript
  // vite.config.js
  import { visualizer } from ''rollup-plugin-visualizer'';
  export default defineConfig({
    plugins: [visualizer({ open: true })],
  });
  ```...', '4e45758d-1053-4937-b961-5a3cef9e566a', 'true', '2025-12-22 03:20:53.753904+00', '2025-12-23 13:59:46.121879+00'), ('16754dea-2ebd-45c8-a8ec-a7516796f5ab', 'React 是什么？', '# 1. 什么是 React？
React 是由 Facebook（现 Meta）于 2013 年开源的**前端 JavaScript 库**，专注于构建用户界面（UI），尤其擅长开发复杂、交互式的单页应用（SPA）。它并非完整的前端框架（如 Angular），而是聚焦于视图层（V 层），可与路由库（React Router）、状态管理库（Redux）等搭配，形成完整的开发解决方案。

核心定位：**用组件化思想构建可复用、高性能的 UI 界面**，让开发者专注于数据变化与 UI 渲染的映射关系，无需手动操作 DOM。

# 2. 核心特性
- **组件化（Component-Based）**：将 UI 拆分为独立、可复用的组件（如按钮、导航栏、表单），组件内部维护自身状态与逻辑，可跨项目复用，降低代码冗余。
- **声明式编程（Declarative）**：开发者只需描述“UI 应该是什么样子”（基于当前数据），React 自动处理“如何渲染”（DOM 操作），相比命令式编程（手动操作 DOM）更简洁、不易出错。
- **虚拟 DOM（Virtual DOM）**：React 不直接操作真实 DOM，而是先在内存中构建虚拟 DOM（JavaScript 对象，映射真实 DOM 结构）。当数据变化时，先对比新旧虚拟 DOM 的差异（Diff 算法），仅将变化的部分更新到真实 DOM，大幅减少 DOM 操作次数，提升性能。
- **单向数据流（One-Way Data Flow）**：数据只能从父组件通过 props 传递给子组件，子组件不能直接修改父组件数据，需通过触发父组件回调函数实现数据更新。这种模式让数据流向清晰，便于调试和维护。
- **JSX 语法**：允许在 JavaScript 中嵌入 HTML 风格的代码，既保留 JavaScript 的灵活性，又简化 UI 结构描述（后续 详细讲解）。

# 3. 设计理念
React 的核心设计理念是“**数据驱动视图**”：UI 是数据的映射，当数据发生变化时，UI 自动同步更新，开发者无需关注 DOM 操作细节。这种理念让开发重心从“操作 DOM”转移到“管理数据”，尤其适合复杂交互场景（如电商购物车、后台管理系统）。

同时，React 强调“**组件化复用**”：通过拆分复杂 UI 为小型组件，实现代码复用和团队协作效率提升。组件具有独立的状态和逻辑，可单独开发、测试和维护。
', '885129c3-bae4-445c-979c-09863b3895f8', 'true', '2025-12-19 06:43:55.588445+00', '2025-12-19 09:04:23.929447+00'), ('17d75ca9-d6a9-43ea-9175-71ae31e35d91', 'useLayoutEffect：同步副作用', '`useLayoutEffect` 是 React 中用于处理**同步副作用**的 Hook，功能与 `useEffect` 类似，但执行时机不同：`useLayoutEffect` 在 DOM 更新后、浏览器绘制前同步执行，而 `useEffect` 在浏览器绘制后异步执行。`useLayoutEffect` 适用于需要同步修改 DOM、获取 DOM 布局信息（如尺寸、位置）的场景，可避免页面闪烁问题。

# 1. useLayoutEffect 与 useEffect 的核心区别
## 1.1 执行时机对比
React 组件渲染/更新的完整流程：
```
1. 组件触发渲染（state/props 变化）
2. 执行组件函数，生成新的虚拟 DOM
3. React 更新真实 DOM（DOM 变化）
4. 执行 useLayoutEffect 副作用（同步，阻塞绘制）
5. 浏览器绘制页面（用户看到更新后的 UI）
6. 执行 useEffect 副作用（异步，不阻塞绘制）
```

| 特性         | useLayoutEffect                  | useEffect                        |
|--------------|---------------------------------|---------------------------------|
| 执行时机     | DOM 更新后、浏览器绘制前（同步） | DOM 更新后、浏览器绘制后（异步） |
| 阻塞性       | 阻塞浏览器绘制（同步执行）| 不阻塞浏览器绘制（异步执行）|
| 适用场景     | 同步修改 DOM、获取布局信息       | 数据请求、订阅、非紧急 DOM 操作  |
| 执行顺序     | 先于 useEffect 执行              | 后于 useLayoutEffect 执行        |
| 视觉影响     | 可避免页面闪烁                   | 可能导致页面闪烁（DOM 操作延迟） |

## 1.2 直观示例：页面闪烁问题
### 场景：根据 DOM 尺寸动态修改样式
```jsx
// 使用 useEffect：可能出现闪烁
function EffectFlash() {
  const [width, setWidth] = useState(0);
  const ref = useRef(null);

  useEffect(() => {
    // 浏览器已绘制页面后执行，修改 DOM 会导致二次绘制（闪烁）
    setWidth(ref.current.offsetWidth);
    ref.current.style.backgroundColor = ''red'';
  }, []);

  return <div ref={ref} style={{ width: ''200px'', height: ''200px'' }}>Effect 示例</div>;
}

// 使用 useLayoutEffect：无闪烁
function LayoutEffectNoFlash() {
  const [width, setWidth] = useState(0);
  const ref = useRef(null);

  useLayoutEffect(() => {
    // 浏览器绘制前执行，DOM 修改一次性完成（无闪烁）
    setWidth(ref.current.offsetWidth);
    ref.current.style.backgroundColor = ''red'';
  }, []);

  return <div ref={ref} style={{ width: ''200px'', height: ''200px'' }}>LayoutEffect 示例</div>;
}
```
- `useEffect` 版本：组件先渲染为默认样式（无背景色），浏览器绘制后执行副作用，修改背景色 → 页面出现“默认样式 → 红色背景”的闪烁。
- `useLayoutEffect` 版本：DOM 更新后立即执行副作用，修改背景色后浏览器才绘制页面 → 直接显示红色背景，无闪烁。

# 2. useLayoutEffect 基本语法与使用场景
## 2.1 基本语法
与 `useEffect` 完全一致，仅执行时机不同：
```jsx
import { useLayoutEffect } from ''react'';

useLayoutEffect(() => {
  // 同步副作用逻辑（DOM 操作、布局计算）

  // 清理函数（可选）
  return () => {
    // 清理资源（如移除事件监听）
  };
}, [依赖项数组]);
```

## 2.2 核心使用场景
### 场景1：获取/修改 DOM 布局信息（尺寸、位置、滚动位置）
需要在浏览器绘制前获取 DOM 布局数据并同步修改，避免闪烁：
```jsx
function ScrollToTop() {
  const ref = useRef(null);

  useLayoutEffect(() => {
    // 组件挂载后，同步滚动到顶部（绘制前完成，无滚动动画闪烁）
    ref.current.scrollTop = 0;
  }, []);

  return <div ref={ref} style={{ height: ''300px'', overflow: ''auto'' }}>
    {/* 长列表内容 */}
  </div>;
}
```

### 场景2：同步修改 DOM 样式（基于布局的动态样式）
根据 DOM 尺寸/位置动态调整样式，需确保样式修改在绘制前完成：
```jsx
function DynamicStyle() {
  const ref = useRef(null);

  useLayoutEffect(() => {
    const dom = ref.current;
    // 根据元素宽度设置字体大小
    if (dom.offsetWidth < 300) {
      dom.style.fontSize = ''14px'';
    } else {
      dom.style.fontSize = ''18px'';
    }
  }, []);

  return <div ref={ref} style={{ width: ''100%'' }}>动态字体大小</div>;
}
```

### 场景3：测量 DOM 元素并更新状态（避免视觉不一致）
测量 DOM 尺寸后更新状态，确保状态与 DOM 同步：
```jsx
function MeasureDom() {
  const [height, setHeight] = useState(0);
  const ref = useRef(null);

  useLayoutEffect(() => {
    // 测量 DOM 高度并更新状态（绘制前完成，状态与 DOM 同步）
    setHeight(ref.current.offsetHeight);
  }, []);

  return (
    <div>
      <div ref={ref}>测量我的高度</div>
      <p>元素高度：{height}px</p>
    </div>
  );
}
```

## 2.3 清理函数
与 `useEffect` 一致，`useLayoutEffect` 的清理函数在组件卸载前或副作用重新执行前执行，且执行时机仍为“绘制前”：
```jsx
function LayoutEffectCleanup() {
  const ref = useRef(null);

  useLayoutEffect(() => {
    const handleResize = () => {
      console.log(''窗口尺寸变化'');
      ref.current.style.width = `${window.innerWidth / 2}px`;
    };

    window.addEventListener(''resize'', handleResize);

    // 清理函数：移除监听（组件卸载前执行）
    return () => {
      window.removeEventListener(''resize'', handleResize);
    };
  }, []);

  return <div ref={ref} style={{ height: ''200px'', backgroundColor: ''blue'' }}>清理示例</div>;
}
```

# 3. useLayoutEffect 的使用注意事项
## 3.1 避免执行耗时操作
`useLayoutEffect` 阻塞浏览器绘制，若执行耗时逻辑（如复杂计算、循环），会导致页面加载/更新延迟，出现卡顿：
```jsx
// 错误示例：耗时操作阻塞绘制
function SlowLayoutEffect() {
  useLayoutEffect(() => {
    // 耗时循环：阻塞浏览器绘制，页面卡顿
    for (let i = 0; i < 1000000000; i++) {}
  }, []);

  return <div>耗时操作示例</div>;
}
```
- 解决方案：耗时操作移至 `useEffect`（异步不阻塞）或 Web Worker（后台执行）。

## 3.2 优先使用 useEffect
`useLayoutEffect` 是“特殊场景”Hook，大部分场景下 `useEffect` 已满足需求，且无阻塞风险。遵循“最小必要原则”：
- 非布局相关的 DOM 操作、数据请求、订阅 → 使用 `useEffect`。
- 仅当需要同步修改 DOM 避免闪烁时 → 使用 `useLayoutEffect`。

## 3.3 服务端渲染（SSR）注意事项
在服务端渲染（如 Next.js）中，`useLayoutEffect` 会在服务端执行时抛出警告（服务端无 DOM，无法执行布局操作）。解决方案：
- 结合 `typeof window !== ''undefined''` 判断环境：
  ```jsx
  function SSRCompatible() {
    const ref = useRef(null);

    useEffect(() => {
      // 仅在客户端执行布局操作（等价于 useLayoutEffect 客户端行为）
      if (ref.current) {
        ref.current.style.backgroundColor = ''red'';
      }
    }, []);

    return <div ref={ref}>SSR 兼容示例</div>;
  }
  ```
- 或使用 `next/dynamic` 动态导入组件（禁用 SSR）。

## 3.4 依赖项数组规则与 useEffect 一致
`useLayoutEffect` 的依赖项数组规则、清理函数逻辑与 `useEffect` 完全相同：
- 空数组 → 仅挂载/卸载时执行。
- 包含依赖项 → 依赖变化时执行。
- 省略数组 → 每次渲染执行。
- 必须包含副作用中使用的所有变量（避免闭包陷阱）。

# 4. useLayoutEffect 与 useEffect 选择原则
1. **优先使用 useEffect**：
   - 数据请求、事件订阅、定时器、非紧急 DOM 操作 → 用 `useEffect`（不阻塞绘制，性能更优）。
2. **必要时使用 useLayoutEffect**：
   - 需要同步获取/修改 DOM 布局信息（尺寸、位置、滚动）→ 用 `useLayoutEffect`（避免闪烁）。
   - 需要确保状态更新与 DOM 同步（无视觉不一致）→ 用 `useLayoutEffect`。
3. **禁止场景**：
   - 耗时操作（如复杂计算、大数据处理）→ 禁止用 `useLayoutEffect`（阻塞页面渲染）。
   - 服务端渲染中的 DOM 操作 → 禁止用 `useLayoutEffect`（服务端无 DOM）。

# 5. 常见误区与避坑指南
## 误区1：滥用 useLayoutEffect 替代 useEffect
将所有副作用都用 `useLayoutEffect` 实现，导致页面卡顿（阻塞绘制）：
```jsx
// 错误示例：数据请求用 useLayoutEffect（阻塞绘制）
function WrongUsage() {
  useLayoutEffect(() => {
    // 数据请求属于异步操作，无需同步执行
    fetch(''/api/data'').then(res => res.json());
  }, []);

  return <div>错误示例</div>;
}
```
- 修正：数据请求改用 `useEffect`。

## 误区2：忽略清理函数导致内存泄漏
与 `useEffect` 一样，`useLayoutEffect` 中添加的事件监听、定时器需在清理函数中移除：
```jsx
// 错误示例：未清理定时器
function LeakExample() {
  useLayoutEffect(() => {
    const timer = setInterval(() => {
      console.log(''定时器执行'');
    }, 1000);
    // 无清理函数 → 组件卸载后定时器仍运行（内存泄漏）
  }, []);

  return <div>内存泄漏示例</div>;
}
```
- 修正：添加清理函数 `return () => clearInterval(timer)`。

## 误区3：依赖项缺失导致闭包陷阱
`useLayoutEffect` 同样存在闭包陷阱，需将副作用中使用的变量加入依赖项数组：
```jsx
// 错误示例：依赖项缺失
function ClosureTrap() {
  const [count, setCount] = useState(0);

  useLayoutEffect(() => {
    // 始终捕获初始 count 值（0），无法获取更新后的值
    console.log(''count：'', count);
  }, []); // 缺失 count 依赖

  return <button onClick={() => setCount(prev => prev + 1)}>+1</button>;
}
```
- 修正：将 `count` 加入依赖项数组 `[count]`。

# 6. 核心总结
1. **核心区别**：与 `useEffect` 唯一差异是执行时机——`useLayoutEffect` 在 DOM 更新后、浏览器绘制前同步执行，`useEffect` 在绘制后异步执行。
2. **核心价值**：解决同步 DOM 操作的页面闪烁问题，确保布局相关修改在浏览器绘制前完成。
3. **使用场景**：
   - 获取/修改 DOM 布局信息（尺寸、位置、滚动）。
   - 同步动态修改 DOM 样式（基于布局的调整）。
   - 测量 DOM 元素并同步更新状态。
4. **避坑要点**：
   - 优先使用 `useEffect`，仅在必要时用 `useLayoutEffect`。
   - 禁止在 `useLayoutEffect` 中执行耗时操作或数据请求。
   - 服务端渲染中避免使用 `useLayoutEffect`（或做客户端判断）。
   - 依赖项和清理函数规则与 `useEffect` 一致。...', 'aac29662-babe-4c96-8f61-0a16830155d4', 'true', '2025-12-19 15:19:19.936943+00', '2025-12-22 02:43:20.869055+00'), ('1807dd75-2e8f-4dfb-80f8-1e8ee994a6c8', 'React Profiler 性能分析工具', 'React Profiler 是 React 官方提供的性能分析工具，集成在 React DevTools 中，用于**定位组件渲染性能问题**（如不必要的重渲染、渲染耗时过长），是 React 性能优化的“诊断利器”。

# 1. 开启 React Profiler
1. 安装 React DevTools 浏览器扩展（Chrome/Firefox）；
2. 打开开发者工具，切换到 `Profiler` 标签；
3. 若提示“Profiling is disabled”，需开启应用的 profiling 模式：
   - 开发环境：React 18 已默认开启，无需配置；
   - 生产环境：需通过 `React.enableProfiling = true` 开启（不建议线上开启）。

# 2. 核心功能与使用流程
## 2.1 基本使用流程
1. **录制性能数据**：
   - 点击 Profiler 面板中的录制按钮（圆形红点）；
   - 操作应用（如点击按钮、滚动列表、输入文本）；
   - 再次点击录制按钮停止录制，生成性能报告。
2. **分析性能报告**：
   - 查看组件渲染次数、渲染耗时；
   - 定位不必要的重渲染、耗时过长的组件；
   - 分析渲染链路（父组件→子组件的渲染触发关系）。

## 2.2 核心视图解读
1. **火焰图（Flame Chart）**：
   - 横向：组件渲染链路（上层为父组件，下层为子组件）；
   - 纵向：组件渲染耗时（高度越高，耗时越长）；
   - 颜色：
     - 蓝色：首次渲染（mount）；
     - 红色：重渲染（update）；
     - 颜色深浅：耗时占比（越深越耗时）。
   - 关键操作：
     - 点击组件块，查看详细信息（渲染原因、耗时、props 变化）；
     - 筛选组件（搜索框输入组件名），聚焦目标组件。

2. **排名图（Ranked Chart）**：
   - 按组件渲染耗时从高到低排序，快速定位最耗时的组件；
   - 显示组件总耗时、平均耗时、渲染次数。

3. **组件图（Component Chart）**：
   - 显示单个组件的渲染历史（每次渲染的耗时、触发原因）；
   - 适合分析特定组件的渲染规律（如是否频繁重渲染）。

## 2.3 关键指标解读
- **Duration**：组件渲染总耗时（包括子组件渲染耗时）；
- **Self Time**：组件自身渲染耗时（不包括子组件）；
- **Count**：组件渲染次数；
- **Render Reason**：组件渲染的触发原因（如 “props changed”、“state changed”、“context changed”）。

# 3. 实战：定位并解决性能问题
## 3.1 场景：列表筛选后卡顿
1. **录制性能数据**：
   - 开启录制，在列表筛选框输入内容，触发列表重渲染；
   - 停止录制，查看火焰图。
2. **分析报告**：
   - 发现 `List` 组件每次筛选耗时 500ms（过长）；
   - 查看 `List` 组件的子组件 `ListItem`，发现所有列表项都重渲染（即使内容未变化）。
3. **定位问题**：
   - `ListItem` 组件未使用 `React.memo` 缓存；
   - 传递给 `ListItem` 的 `onClick` 函数每次渲染生成新引用。
4. **解决问题**：
   - 用 `React.memo` 包装 `ListItem` 组件；
   - 用 `useCallback` 缓存 `onClick` 函数；
   - 重新录制，验证 `ListItem` 仅在内容变化时重渲染，列表筛选耗时降至 50ms。

## 3.2 场景：父组件重渲染导致子组件无意义重渲染
1. **录制性能数据**：
   - 点击父组件的按钮（修改自身 state），触发父组件重渲染；
   - 发现子组件 `Child` 也重渲染（props 未变化）。
2. **定位问题**：
   - `Child` 组件未使用 `React.memo` 缓存；
   - 父组件传递给 `Child` 的 `user` 对象每次渲染生成新引用。
3. **解决问题**：
   - 用 `React.memo` 包装 `Child` 组件；
   - 用 `useMemo` 缓存 `user` 对象；
   - 重新录制，验证 `Child` 不再因父组件重渲染而重渲染。

# 4. 使用注意事项
1. **开发环境使用**：Profiler 会增加性能开销，仅在开发环境分析，生产环境禁用；
2. **模拟真实场景**：分析时使用真实数据量（如 1000 条列表项），避免测试环境数据量过小导致问题隐藏；
3. **多次录制验证**：单次录制可能受网络、浏览器卡顿影响，多次录制取平均值；
4. **结合其他工具**：Profiler 定位渲染问题，Chrome Performance 工具分析 JS 执行、DOM 重排耗时，全面排查性能瓶颈。

## 5. 性能优化的闭环流程
1. **测量**：用 React Profiler 录制性能数据，定位瓶颈；
2. **优化**：根据瓶颈类型（重渲染/耗时计算/长列表），使用对应优化策略；
3. **验证**：重新录制性能数据，确认优化效果；
4. **迭代**：重复上述步骤，直到性能达标。
', 'e9432055-c489-48b5-964a-81d34278fc72', 'true', '2025-12-22 03:16:38.599933+00', '2025-12-23 09:48:34.189832+00'), ('2a4fe712-3365-4605-9faf-d81931a23f20', 'Webpack 配置 React 项目', '# 1. Webpack 核心概念
Webpack 是一个静态模块打包工具，核心概念包括：
- **入口（Entry）**：项目打包的起始文件（如 `src/index.js`）；
- **输出（Output）**：打包后的文件路径与名称；
- **Loader**：处理非 JS/TS 文件（如 JSX、CSS、图片），将其转为模块；
- **Plugin**：执行打包后的优化、压缩、资源管理等任务（如 HtmlWebpackPlugin）；
- **模式（Mode）**：分为 `development`（开发）、`production`（生产）、`none`，不同模式下内置不同优化。

# 2. 手动搭建 Webpack + React 项目
## 2.1 初始化项目
```bash
mkdir my-react-webpack-project
cd my-react-webpack-project
npm init -y # 初始化 package.json
```

## 2.2 安装核心依赖
```bash
npm install react react-dom

npm install -D webpack webpack-cli webpack-dev-server

npm install -D @babel/core @babel/preset-env @babel/preset-react babel-loader

npm install -D html-webpack-plugin

npm install -D clean-webpack-plugin
```

## 2.3 创建项目目录结构
```
my-react-webpack-project/
├── src/
│   ├── App.js
│   └── index.js
├── public/
│   └── index.html
├── webpack.config.js # Webpack 配置文件
└── package.json
```

# 3. Webpack 基础配置（webpack.config.js）
## 3.1 基础结构
```javascript
const path = require(''path'');
const HtmlWebpackPlugin = require(''html-webpack-plugin'');
const { CleanWebpackPlugin } = require(''clean-webpack-plugin'');

module.exports = {
  // 入口
  entry: ''./src/index.js'',
  // 输出
  output: {
    path: path.resolve(__dirname, ''dist''), // 打包输出目录
    filename: ''js/[name].[hash].js'', // 输出文件名（带哈希防缓存）
    publicPath: ''/'', // 公共路径
  },
  // 模式
  mode: ''development'',
  // 开发服务器
  devServer: {
    port: 3000, // 端口
    open: true, // 自动打开浏览器
    hot: true, // 热更新
    historyApiFallback: true, // 支持 React Router 路由刷新
  },
  // 模块解析规则
  module: {
    rules: [
      // 处理 JS/JSX（Babel）
      {
        test: /\.(js|jsx)$/,
        exclude: /node_modules/, // 排除 node_modules
        use: ''babel-loader'',
      },
    ],
  },
  // 插件
  plugins: [
    new CleanWebpackPlugin(), // 清理 dist 目录
    new HtmlWebpackPlugin({
      template: ''./public/index.html'', // 模板 HTML
      filename: ''index.html'', // 输出 HTML 名称
      inject: ''body'', // 将 JS 注入到 body 底部
    }),
  ],
  // 解析别名
  resolve: {
    extensions: [''.js'', ''.jsx''], // 省略文件后缀
    alias: {
      ''@'': path.resolve(__dirname, ''src''), // 路径别名
    },
  },
};
```

## 3.2 配置 Babel（.babelrc 或 babel.config.json）
创建 `.babelrc` 文件，配置 Babel 预设：
```json
{
  "presets": [
    "@babel/preset-env", // 转换 ES6+ 为 ES5
    ["@babel/preset-react", { "runtime": "automatic" }] // 转换 JSX，自动导入 React
  ]
}
```

## 3.3 编写 React 基础代码
- `public/index.html`：
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Webpack + React</title>
</head>
<body>
  <div id="root"></div>
</body>
</html>
```
- `src/App.js`：
```jsx
import React from ''react'';

const App = () => {
  return <h1>Hello Webpack + React!</h1>;
};

export default App;
```
- `src/index.js`：
```jsx
import React from ''react'';
import ReactDOM from ''react-dom/client'';
import App from ''./App'';

const root = ReactDOM.createRoot(document.getElementById(''root''));
root.render(<App />);
```

## 3.4 配置 npm 脚本
修改 `package.json`：
```json
"scripts": {
  "start": "webpack serve --config webpack.config.js",
  "build": "webpack --config webpack.config.js --mode production"
}
```
启动项目：
```bash
npm run start # 开发环境
npm run build # 生产打包
```

# 4. Loader 配置（处理非 JS 资源）
## 4.1 处理 CSS/Scss
```bash

npm install -D style-loader css-loader sass sass-loader
```
在 `webpack.config.js` 的 `module.rules` 中添加：
```javascript
// 处理 CSS
{
  test: /\.css$/,
  use: [''style-loader'', ''css-loader''], // 顺序：从右到左执行
},
// 处理 Scss
{
  test: /\.scss$/,
  use: [''style-loader'', ''css-loader'', ''sass-loader''],
},
```
- `css-loader`：解析 CSS 文件；
- `style-loader`：将 CSS 注入到 DOM 中；
- `sass-loader`：编译 Scss 为 CSS。

## 4.2 处理图片/字体资源
```bash
npm install -D file-loader url-loader asset-modules
```
Webpack 5 内置 `asset-modules`，无需额外安装 loader：
```javascript
// 处理图片
{
  test: /\.(png|jpg|jpeg|gif|svg)$/,
  type: ''asset'',
  parser: {
    dataUrlCondition: {
      maxSize: 8 * 1024, // 小于 8KB 的图片转为 base64
    },
  },
  generator: {
    filename: ''images/[name].[hash][ext]'', // 输出路径
  },
},
// 处理字体
{
  test: /\.(woff|woff2|eot|ttf|otf)$/,
  type: ''asset/resource'',
  generator: {
    filename: ''fonts/[name].[hash][ext]'',
  },
},
```

## 4.3 处理 TypeScript
```bash
npm install -D typescript ts-loader @babel/preset-typescript
npm install -D @types/react @types/react-dom
```
- 创建 `tsconfig.json`：
```json
{
  "compilerOptions": {
    "target": "ES5",
    "module": "ESNext",
    "jsx": "react-jsx",
    "strict": true,
    "esModuleInterop": true,
    "resolveJsonModule": true,
    "baseUrl": "./",
    "paths": {
      "@/*": ["src/*"]
    }
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules"]
}
```
- 修改 Webpack 配置：
```javascript
module: {
  rules: [
    {
      test: /\.(ts|tsx)$/,
      exclude: /node_modules/,
      use: ''ts-loader'', // 或 babel-loader（需配置 @babel/preset-typescript）
    },
  ],
},
resolve: {
  extensions: [''.ts'', ''.tsx'', ''.js'', ''.jsx''],
},
```

# 5. Plugin 配置（优化与扩展）
## 5.1 核心插件详解
1. **HtmlWebpackPlugin**：生成 HTML 文件并自动引入打包后的 JS/CSS；
2. **CleanWebpackPlugin**：每次打包前清理输出目录；
3. **MiniCssExtractPlugin**：生产环境下将 CSS 提取为单独文件（替代 style-loader）：
   ```bash
   npm install -D mini-css-extract-plugin
   ```
   ```javascript
   const MiniCssExtractPlugin = require(''mini-css-extract-plugin'');

   module.exports = {
     module: {
       rules: [
         {
           test: /\.css$/,
           use: [MiniCssExtractPlugin.loader, ''css-loader''], // 生产环境使用
         },
       ],
     },
     plugins: [
       new MiniCssExtractPlugin({
         filename: ''css/[name].[hash].css'',
       }),
     ],
   };
   ```
4. **DefinePlugin**：定义全局常量（如环境变量）：
   ```javascript
   const { DefinePlugin } = require(''webpack'');

   plugins: [
     new DefinePlugin({
       ''process.env.NODE_ENV'': JSON.stringify(process.env.NODE_ENV),
       ''process.env.REACT_APP_API_URL'': JSON.stringify(''http://api.example.com''),
     }),
   ];
   ```
5. **HotModuleReplacementPlugin**：开启热更新（开发环境）：
   ```javascript
   const { HotModuleReplacementPlugin } = require(''webpack'');

   plugins: [new HotModuleReplacementPlugin()],
   devServer: { hot: true },
   ```
6. **TerserPlugin**：生产环境压缩 JS 代码（Webpack 5 生产模式下默认开启）：
   ```bash
   npm install -D terser-webpack-plugin
   ```
   ```javascript
   const TerserPlugin = require(''terser-webpack-plugin'');

   module.exports = {
     optimization: {
       minimizer: [
         new TerserPlugin({
           parallel: true, // 多线程压缩
           terserOptions: {
             compress: { drop_console: true }, // 移除 console
           },
         }),
       ],
     },
   };
   ```

## 5.2 代码分割（Code Splitting）
通过 `optimization.splitChunks` 分割第三方依赖与业务代码：
```javascript
module.exports = {
  optimization: {
    splitChunks: {
      chunks: ''all'', // 分割所有模块（同步 + 异步）
      cacheGroups: {
        vendors: {
          test: /[\\/]node_modules[\\/]/,
          name: ''vendors'', // 第三方依赖打包为 vendors.js
          priority: -10,
        },
        common: {
          name: ''common'', // 公共业务代码打包为 common.js
          minChunks: 2, // 至少被 2 个模块引用
          priority: -20,
          reuseExistingChunk: true,
        },
      },
    },
    runtimeChunk: ''single'', // 将运行时代码分割为单独文件
  },
};
```

# 6. 开发与生产环境配置分离
大型项目建议拆分配置文件：
- `webpack.common.js`：公共配置；
- `webpack.dev.js`：开发环境配置（继承公共配置）；
- `webpack.prod.js`：生产环境配置（继承公共配置）。

使用 `webpack-merge` 合并配置：
```bash
npm install -D webpack-merge
```
示例（`webpack.dev.js`）：
```javascript
const { merge } = require(''webpack-merge'');
const common = require(''./webpack.common.js'');
const { HotModuleReplacementPlugin } = require(''webpack'');

module.exports = merge(common, {
  mode: ''development'',
  devtool: ''inline-source-map'', // 开发环境 sourcemap
  devServer: {
    hot: true,
    open: true,
  },
  plugins: [new HotModuleReplacementPlugin()],
});
```

# 7. 常见优化策略
1. **缩小打包范围**：通过 `exclude`/`include` 限定 loader 处理范围；
2. **开启缓存**：`cache-loader` 或 Webpack 5 内置缓存：
   ```javascript
   module.exports = {
     cache: {
       type: ''filesystem'', // 文件系统缓存
     },
   };
   ```
3. **Tree Shaking**：生产模式下默认开启，需确保代码为 ES 模块（不可使用 CommonJS）；
4. **CDN 引入第三方库**：通过 `externals` 排除无需打包的依赖：
   ```javascript
   module.exports = {
     externals: {
       react: ''React'',
       ''react-dom'': ''ReactDOM'',
     },
   };
   ```
   然后在 HTML 中引入 CDN：
   ```html
   <script src="https://cdn.jsdelivr.net/npm/react@18/umd/react.production.min.js"></script>
   <script src="https://cdn.jsdelivr.net/npm/react-dom@18/umd/react-dom.production.min.js"></script>
   ```

# 8. 与 CRA 的区别
CRA（Create React App）是官方封装的 Webpack 配置，无需手动配置，但灵活性低；手动配置 Webpack 可完全掌控打包流程，适合复杂项目（如需要自定义 loader、plugin、代码分割策略）。

# 9. 常见问题解决
- **热更新不生效**：确保开启 `HotModuleReplacementPlugin` 且 `devServer.hot = true`；
- **打包体积过大**：开启代码分割、Tree Shaking、CDN 引入第三方库；
- **TypeScript 类型报错**：检查 `tsconfig.json` 配置，确保 `jsx` 模式正确；
- **路径别名不生效**：Webpack 与 `tsconfig.json` 需同步配置别名。...', 'd8343213-03f7-4f4f-b6e3-6926e0f500a1', 'true', '2025-12-22 03:19:38.515843+00', '2025-12-23 13:20:16.945415+00'), ('2c38b02a-e848-4b13-a42a-cf84c3efe428', 'useState/Context vs Zustand vs Redux', '前端状态管理的核心目标是**统一管理、高效共享、可预测更新**，不同方案的设计理念和能力差异显著，选择的核心原则是：**匹配项目规模、团队熟悉度、状态复杂度**。以下从核心特性、优缺点、适用场景三方面深度对比三大主流方案。

# 1. useState + Context（React 原生方案）
## 1.1 核心特性
- `useState`：管理组件内部局部状态，触发组件重渲染；
- `Context`：创建全局上下文，通过 `Provider` 注入状态，`useContext` 读取状态，实现跨组件共享；
- 无额外依赖，完全基于 React 原生 API；
- 状态更新会触发所有消费 `Context` 的组件重渲染（即使只用到部分状态）。

## 1.2 优缺点
| 优点 | 缺点 |
|------|------|
| 零学习成本，React 开发者天然掌握 | 状态粒度粗，更新时全局消费组件重渲染（性能瓶颈） |
| 无需安装第三方库，减小打包体积 | 缺乏内置的异步处理、持久化、中间件等能力 |
| 轻量简单，适合小型场景 | 状态逻辑分散，复杂场景下（如多模块联动）代码冗余 |
| 原生集成，与 React 生命周期深度兼容 | 无调试工具，状态变化追踪困难 |

## 1.3 适用场景
- **小型项目/独立组件**：如个人博客、简单表单页面、单组件内的状态共享（如弹窗显隐、表单输入）；
- **原型开发**：快速验证功能，无需引入复杂工具；
- **局部状态共享**：跨 2-3 层组件的状态传递（如父组件向深层子组件传值，替代 props 透传）；
- **无复杂异步逻辑**：状态更新仅依赖同步操作，无需处理 API 请求、定时器等异步场景。

## 1.4 典型示例（Theme 切换）
```javascript
// 创建 Context
const ThemeContext = React.createContext();

// 提供状态的 Provider 组件
function ThemeProvider({ children }) {
  const [theme, setTheme] = useState(''light'');
  
  const toggleTheme = () => {
    setTheme(prev => prev === ''light'' ? ''dark'' : ''light'');
  };
  
  return (
    <ThemeContext.Provider value={{ theme, toggleTheme }}>
      {children}
    </ThemeContext.Provider>
  );
}

// 消费状态的组件
function Header() {
  const { theme, toggleTheme } = useContext(ThemeContext);
  return (
    <header className={theme}>
      <button onClick={toggleTheme}>切换主题</button>
    </header>
  );
}
```

# 2. Zustand（轻量级集中式状态管理）
## 2.1 核心特性
- 基于发布-订阅模式，状态存储在独立的 store 中（非 React 组件内）；
- 通过 `useStore` Hook 订阅状态，仅当订阅的状态变化时组件才重渲染（精准更新）；
- 支持中间件（如持久化、日志）、异步操作（无需额外依赖）、状态分片；
- 体积小巧（约 1KB gzip），API 极简，无 Provider 嵌套；
- 支持 TypeScript 友好，天然类型提示。

## 2.2 优缺点
| 优点 | 缺点 |
|------|------|
| 体积小，性能优（精准重渲染） | 生态不如 Redux 丰富（第三方工具、插件较少） |
| API 简洁，学习成本低（比 Redux 简单） | 大型项目中状态模块化需手动规范（无强制约束） |
| 内置异步支持（store 中可直接写 async/await） | 调试工具功能较基础（依赖 Redux DevTools 兼容层） |
| 无 Provider 嵌套，组件层级更清晰 | 不适用于非 React 环境（专注 React 生态） |

## 2.3 适用场景
- **中小型项目**：如管理后台、电商小程序、需要跨组件共享状态但逻辑不极端复杂的应用；
- **对性能敏感的场景**：避免 Context 全局重渲染问题（如列表页、高频更新的状态）；
- **团队追求开发效率**：不想引入 Redux 复杂的概念（Action/Reducer/中间件），快速实现状态共享；
- **需要持久化/异步逻辑**：如用户登录状态持久化、API 请求状态管理（无需额外配置中间件）；
- **TypeScript 项目**：天然的类型支持，减少类型定义工作量。

## 2.4 典型示例（待办事项 Store）
```javascript
// 创建 store
import { create } from ''zustand'';
import { persist } from ''zustand/middleware'';

const useTodoStore = create(
  persist(
    (set) => ({
      todos: [],
      // 同步操作
      addTodo: (text) => set((state) => ({
        todos: [...state.todos, { id: Date.now(), text, completed: false }]
      })),
      // 异步操作
      fetchTodos: async () => {
        const res = await fetch(''https://jsonplaceholder.typicode.com/todos'');
        const data = await res.json();
        set({ todos: data.slice(0, 10) });
      }
    }),
    { name: ''todo-storage'' } // 持久化到 localStorage
  )
);

// 消费组件
function TodoList() {
  // 仅订阅 todos 状态，仅 todos 变化时重渲染
  const todos = useTodoStore((state) => state.todos);
  const fetchTodos = useTodoStore((state) => state.fetchTodos);
  
  useEffect(() => {
    fetchTodos();
  }, [fetchTodos]);
  
  return (
    <ul>
      {todos.map((todo) => (
        <li key={todo.id}>{todo.title}</li>
      ))}
    </ul>
  );
}
```

# 3. Redux（重量级集中式状态管理）
## 3.1 核心特性
- 严格遵循单向数据流，状态存储在单一 Store 中；
- 基于 Action/Reducer 模式，状态更新可预测、可追踪；
- 丰富的中间件生态（Thunk/Saga/Observable），处理复杂异步逻辑；
- 强大的调试工具（Redux DevTools），支持时间旅行、状态回溯；
- 跨框架兼容（可用于 React/Vue/原生 JS 项目）；
- Redux Toolkit 简化样板代码，成为官方推荐写法。

## 3.2 优缺点
| 优点 | 缺点 |
|------|------|
| 状态变化完全可预测，适合大型团队协作 | 学习成本高（Action/Reducer/中间件/单向数据流等概念） |
| 强大的调试工具，便于定位问题 | 样板代码多（原生 Redux，RTK 已优化） |
| 丰富的生态系统，解决方案成熟 | 体积较大（含中间件后），小型项目过度设计 |
| 强制规范的状态管理流程，代码可维护性高 | 简单场景下开发效率低（相比 Zustand/Context） |
| 跨框架复用，状态逻辑与 UI 解耦 | 组件与 Redux 耦合度较高（需 Provider/useSelector） |

## 3.3 适用场景
- **大型复杂项目**：如企业级后台、电商平台、多人协作的大型应用（状态模块多、联动逻辑复杂）；
- **需要严格状态追踪**：如金融、医疗等对状态可追溯性要求高的领域；
- **复杂异步流程**：如并发请求、依赖请求、任务取消/重试（Redux-Saga 擅长处理）；
- **跨框架项目**：状态逻辑需在 React 与其他框架（如 Vue）之间复用；
- **团队需要强规范**：通过 Redux 的强制流程约束代码风格，降低协作成本。

## 3.4 典型场景（电商购物车）
- 购物车状态需同步到多个组件（商品列表、结算页、导航栏）；
- 需处理商品添加/删除/修改数量的同步逻辑；
- 需处理库存检查、价格计算等异步逻辑；
- 需持久化购物车数据，支持页面刷新后恢复；
- 需通过调试工具追踪购物车状态变化，定位问题。

# 4. 核心对比总结表
| 维度                | useState + Context       | Zustand                  | Redux（RTK）|
|---------------------|--------------------------|--------------------------|--------------------------|
| 学习成本            | 极低（原生 API）| 低（极简 API）| 高（多概念）|
| 性能                | 差（全局重渲染）| 优（精准订阅）| 中（精准订阅）|
| 调试能力            | 无                       | 基础（兼容 DevTools）| 极强（DevTools 全功能）|
| 异步处理            | 需手动实现               | 内置支持（async/await）| 中间件支持（Thunk/Saga）|
| 持久化              | 需手动实现               | 内置中间件               | 需插件（redux-persist）|
| 团队协作友好性      | 差（无规范）| 中（需手动规范）| 优（强制规范）|
| 打包体积            | 0（原生）| 极小（~1KB）| 中等（~10KB+）|
| 适用项目规模        | 小型/原型                | 中小型/中型              | 中大型/大型              |

# 5. 选择建议
1. **优先用 useState + Context**：
   - 项目规模小（单页面、少量组件）；
   - 状态仅在局部组件共享；
   - 无复杂异步逻辑；
   - 追求零依赖、快速开发。

2. **优先用 Zustand**：
   - 中小型项目，需要跨组件状态共享；
   - 对性能有要求（避免全局重渲染）；
   - 需简单异步处理/持久化；
   - 不想引入 Redux 的复杂概念；
   - TypeScript 项目追求简洁类型支持。

3. **优先用 Redux**：
   - 大型项目，多人协作；
   - 状态逻辑复杂（多模块联动、复杂异步）；
   - 需严格的状态追踪和调试；
   - 跨框架复用状态逻辑；
   - 团队需要强规范约束。', '7a39499e-a54e-4dd5-89ed-f24202ec0992', 'true', '2025-12-22 03:13:52.354574+00', '2025-12-23 09:07:05.118703+00'), ('2c480f6d-15ba-4ed9-8589-727c24aa663b', 'React 性能优化核心思路', 'React 应用的性能瓶颈主要集中在两个方面：**不必要的组件渲染**（重复执行 render 函数）和**昂贵的计算操作**（如复杂数据处理、DOM 操作）。性能优化的核心思路可总结为：**减少渲染次数、优化渲染过程、降低计算开销**，最终实现“更快的首屏加载、更流畅的交互响应”。

# 1. 减少渲染次数（核心方向）
组件渲染是 React 最核心的性能消耗点，每次渲染会执行 render 函数、对比虚拟 DOM、更新真实 DOM（若有差异）。减少渲染次数的关键是：让组件仅在必要时渲染（状态/属性真正变化时）。

## 1.1 避免不必要的重渲染触发条件
React 组件重渲染的触发条件：
- 组件自身 `state` 变化；
- 父组件重渲染（即使子组件 props 未变化）；
- 上下文（Context）值变化（所有消费上下文的组件重渲染）；
- 强制触发（`forceUpdate`）。

## 1.2 减少重渲染的核心策略
1. **精准控制 props 传递**：
   - 避免传递不稳定的 props（如每次渲染生成新对象/数组/函数）；
   - 拆分组件，让子组件仅接收必要的 props（避免因无关 props 变化触发重渲染）。
2. **优化 Context 使用**：
   - 将大上下文拆分为多个小上下文（如用户信息上下文、主题上下文），避免一处变化导致所有组件重渲染；
   - 上下文值仅存储全局共享状态，不存储局部状态。
3. **使用缓存工具**：
   - 用 `React.memo` 缓存组件（避免父组件重渲染导致子组件无意义重渲染）；
   - 用 `useMemo` 缓存计算结果、`useCallback` 缓存函数（避免生成新引用触发重渲染）。

# 2. 优化渲染过程（减少渲染耗时）
即使无法避免渲染，也可通过优化渲染过程降低耗时：
1. **简化虚拟 DOM 结构**：
   - 减少组件嵌套层级（避免深层组件树增加 Diff 算法耗时）；
   - 移除无用的 DOM 节点和组件（如空 div、隐藏的冗余组件）。
2. **延迟渲染非关键内容**：
   - 用 `React.lazy` + `Suspense` 懒加载非首屏组件；
   - 用 `useTransition` 标记非紧急渲染（如列表筛选结果），优先保证用户交互响应。
3. **避免渲染期间的昂贵操作**：
   - 不在 render 函数、JSX 中执行复杂计算（如数组排序、数据格式化）；
   - 不在组件挂载时同步执行大量数据处理（改为异步或分批次执行）。

# 3. 降低计算开销（减少非渲染耗时）
除渲染外，应用中的计算操作（如数据处理、事件处理）也可能导致性能问题：
1. **缓存计算结果**：
   - 用 `useMemo` 缓存重复计算的结果（如列表过滤、统计数据）；
   - 用全局缓存（如 localStorage、Redux）存储高频访问的静态数据（如字典表）。
2. **优化数据处理**：
   - 避免在循环中执行 DOM 操作、API 请求；
   - 对大数据集采用分批次处理（如分页加载、虚拟列表）。
3. **使用高效的算法和数据结构**：
   - 用 Map/Set 替代数组进行查找操作（时间复杂度从 O(n) 降至 O(1)）；
   - 对列表排序使用稳定的排序算法（如快速排序），避免重复排序。

# 4. 性能优化的优先级
性能优化需遵循“先瓶颈后细节”的原则，优先级从高到低：
1. **首屏加载优化**：
   - 代码分割（路由级/组件级）、懒加载；
   - 静态资源压缩（JS/CSS/图片）、CDN 加速；
   - 服务端渲染（SSR）/静态站点生成（SSG）（针对 SEO 敏感、首屏耗时高的应用）。
2. **交互响应优化**：
   - 减少重渲染、优化渲染过程；
   - 用 `useTransition` 处理非紧急更新，避免阻塞用户输入。
3. **长尾优化**：
   - 优化大数据集处理、复杂计算；
   - 修复内存泄漏（如未清除的定时器、事件监听）。', 'e9432055-c489-48b5-964a-81d34278fc72', 'true', '2025-12-22 03:15:29.624469+00', '2025-12-23 09:41:01.887886+00'), ('32ad2319-a792-4713-bb15-7bc3201cefe6', '自定义组件封装', '# 1. 组件封装核心原则
1. **单一职责**：一个组件只负责一个功能（如按钮组件不处理表单逻辑）；
2. **可复用性**：通过 Props 暴露配置项，适配不同业务场景；
3. **可维护性**：代码结构清晰，注释完善，逻辑解耦；
4. **可扩展性**：支持二次封装，预留扩展接口；
5. **类型安全**：TypeScript 定义完整的 Props 类型，避免隐式错误；
6. **用户体验**：兼容无障碍访问（ARIA 标签）、支持键盘操作。

# 2. 按钮组件封装
## 2.1 需求分析
- 支持基础样式（主按钮、次按钮、危险按钮、文本按钮）；
- 支持尺寸（小、中、大）；
- 支持加载状态、禁用状态；
- 支持图标、自定义颜色；
- 支持点击事件、防抖处理。

## 2.2 代码实现
```tsx
// components/MyButton/MyButton.tsx
import React, { useState, useCallback } from ''react'';
import { Spin } from ''antd''; // 复用 AntD 加载组件（或自定义）
import { LoadingOutlined } from ''@ant-design/icons'';
import ''./MyButton.less'';

// 定义 Props 类型
export interface MyButtonProps {
  /** 按钮类型 */
  type?: ''primary'' | ''secondary'' | ''danger'' | ''text'';
  /** 按钮尺寸 */
  size?: ''small'' | ''middle'' | ''large'';
  /** 按钮文本 */
  children: React.ReactNode;
  /** 点击事件 */
  onClick?: (e: React.MouseEvent<HTMLButtonElement>) => void;
  /** 是否禁用 */
  disabled?: boolean;
  /** 是否加载中 */
  loading?: boolean;
  /** 防抖时间（ms） */
  debounceTime?: number;
  /** 自定义类名 */
  className?: string;
  /** 自定义样式 */
  style?: React.CSSProperties;
  /** 图标（前置） */
  prefixIcon?: React.ReactNode;
  /** 图标（后置） */
  suffixIcon?: React.ReactNode;
}

const MyButton: React.FC<MyButtonProps> = ({
  type = ''primary'',
  size = ''middle'',
  children,
  onClick,
  disabled = false,
  loading = false,
  debounceTime = 0,
  className = '''',
  style,
  prefixIcon,
  suffixIcon,
}) => {
  // 防抖逻辑
  const [isClicking, setIsClicking] = useState(false);
  const debouncedClick = useCallback(
    (e: React.MouseEvent<HTMLButtonElement>) => {
      if (disabled || loading || isClicking) return;
      if (debounceTime > 0) {
        setIsClicking(true);
        setTimeout(() => {
          onClick?.(e);
          setIsClicking(false);
        }, debounceTime);
      } else {
        onClick?.(e);
      }
    },
    [onClick, disabled, loading, debounceTime, isClicking]
  );

  // 拼接类名
  const baseClassName = `my-button my-button--${type} my-button--${size}`;
  const finalClassName = [baseClassName, className].filter(Boolean).join('' '');

  return (
    <button
      className={finalClassName}
      style={style}
      onClick={debouncedClick}
      disabled={disabled || loading}
      aria-disabled={disabled || loading}
      aria-label={children as string}
    >
      <span className="my-button__content">
        {loading && <Spin indicator={<LoadingOutlined />} size="small" className="my-button__loading" />}
        {prefixIcon && <span className="my-button__prefix-icon">{prefixIcon}</span>}
        {!loading && <span className="my-button__text">{children}</span>}
        {suffixIcon && <span className="my-button__suffix-icon">{suffixIcon}</span>}
      </span>
    </button>
  );
};

export default MyButton;
```

```less
// components/MyButton/MyButton.less
.my-button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 4px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.2s ease;
  font-size: 14px;
  font-weight: 500;
  padding: 0 16px;
  box-sizing: border-box;

  &--small {
    height: 32px;
    font-size: 12px;
  }

  &--middle {
    height: 40px;
  }

  &--large {
    height: 48px;
    font-size: 16px;
    padding: 0 20px;
  }

  &--primary {
    background-color: #1890ff;
    color: #fff;

    &:hover:not(:disabled) {
      background-color: #40a9ff;
    }

    &:active:not(:disabled) {
      background-color: #096dd9;
    }
  }

  &--secondary {
    background-color: #f5f5f5;
    color: #333;
    border: 1px solid #d9d9d9;

    &:hover:not(:disabled) {
      background-color: #e6e6e6;
    }
  }

  &--danger {
    background-color: #ff4d4f;
    color: #fff;

    &:hover:not(:disabled) {
      background-color: #ff7875;
    }
  }

  &--text {
    background-color: transparent;
    color: #1890ff;
    padding: 0 8px;

    &:hover:not(:disabled) {
      background-color: #f0f7ff;
    }
  }

  &:disabled {
    opacity: 0.6;
    cursor: not-allowed;
  }

  &__content {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 4px;
  }

  &__loading {
    margin-right: 4px;
  }

  &__prefix-icon,
  &__suffix-icon {
    display: flex;
    align-items: center;
  }
}
```

## 2.3 使用示例
```tsx
import MyButton from ''./components/MyButton/MyButton'';
import { SearchOutlined } from ''@ant-design/icons'';

const App = () => {
  const handleClick = () => {
    console.log(''按钮点击'');
  };

  return (
    <div style={{ padding: 20, gap: 16, display: ''flex'' }}>
      <MyButton type="primary" onClick={handleClick}>
        主按钮
      </MyButton>
      <MyButton type="danger" loading>
        危险按钮（加载中）
      </MyButton>
      <MyButton type="text" prefixIcon={<SearchOutlined />} debounceTime={500}>
        文本按钮（防抖）
      </MyButton>
      <MyButton type="secondary" size="large" disabled>
        大尺寸禁用按钮
      </MyButton>
    </div>
  );
};
```

# 3. 表单组件封装
## 3.1 需求分析
- 基于 AntD Form 二次封装，简化表单配置；
- 支持表单项配置化（通过数组定义表单项）；
- 支持表单验证、提交、重置；
- 支持自定义表单项、布局调整。

## 3.2 代码实现
```tsx
// components/MyForm/MyForm.tsx
import React from ''react'';
import { Form, Input, Select, InputNumber, Checkbox, FormProps as AntdFormProps } from ''antd'';
import MyButton from ''../MyButton/MyButton'';
import ''./MyForm.less'';

// 定义表单项类型
export type FormItemType = ''input'' | ''select'' | ''inputNumber'' | ''checkbox'' | ''custom'';

export interface FormItemConfig {
  /** 表单项字段名 */
  name: string;
  /** 表单项类型 */
  type: FormItemType;
  /** 表单项标签 */
  label: string;
  /** 表单项占位符 */
  placeholder?: string;
  /** 表单项规则 */
  rules?: AntdFormProps[''rules''][number][];
  /** 下拉选项（select 类型） */
  options?: { label: string; value: string | number }[];
  /** 自定义组件（custom 类型） */
  customComponent?: React.ReactNode;
  /** 表单项属性（透传到底层组件） */
  props?: Record<string, any>;
  /** 表单项占宽（栅格数） */
  span?: number;
}

export interface MyFormProps {
  /** 表单项配置 */
  items: FormItemConfig[];
  /** 表单初始值 */
  initialValues?: AntdFormProps[''initialValues''];
  /** 表单提交事件 */
  onFinish: AntdFormProps[''onFinish''];
  /** 表单提交失败事件 */
  onFinishFailed?: AntdFormProps[''onFinishFailed''];
  /** 表单布局（水平/垂直） */
  layout?: ''horizontal'' | ''vertical'';
  /** 提交按钮文本 */
  submitText?: string;
  /** 是否显示重置按钮 */
  showReset?: boolean;
  /** 自定义样式 */
  style?: React.CSSProperties;
  /** 自定义类名 */
  className?: string;
}

const MyForm: React.FC<MyFormProps> = ({
  items,
  initialValues,
  onFinish,
  onFinishFailed,
  layout = ''horizontal'',
  submitText = ''提交'',
  showReset = true,
  style,
  className,
}) => {
  const [form] = Form.useForm();

  // 渲染表单项
  const renderFormItem = (item: FormItemConfig) => {
    const { name, type, label, placeholder, options, customComponent, props, span = 24 } = item;

    const formItemProps = {
      name,
      label,
      rules: item.rules,
      className: `my-form-item my-form-item--${span}`,
    };

    switch (type) {
      case ''input'':
        return (
          <Form.Item {...formItemProps}>
            <Input placeholder={placeholder} {...props} />
          </Form.Item>
        );
      case ''select'':
        return (
          <Form.Item {...formItemProps}>
            <Select placeholder={placeholder} options={options} {...props} />
          </Form.Item>
        );
      case ''inputNumber'':
        return (
          <Form.Item {...formItemProps}>
            <InputNumber placeholder={placeholder} {...props} />
          </Form.Item>
        );
      case ''checkbox'':
        return (
          <Form.Item {...formItemProps} valuePropName="checked">
            <Checkbox {...props}>{label}</Checkbox>
          </Form.Item>
        );
      case ''custom'':
        return <Form.Item {...formItemProps}>{customComponent}</Form.Item>;
      default:
        return null;
    }
  };

  // 重置表单
  const handleReset = () => {
    form.resetFields();
  };

  return (
    <Form
      form={form}
      layout={layout}
      initialValues={initialValues}
      onFinish={onFinish}
      onFinishFailed={onFinishFailed}
      className={`my-form ${className || ''''}`}
      style={style}
    >
      <div className="my-form__items">
        {items.map((item, index) => (
          <React.Fragment key={`${item.name}-${index}`}>{renderFormItem(item)}</React.Fragment>
        ))}
      </div>
      <div className="my-form__actions">
        <MyButton type="primary" htmlType="submit">
          {submitText}
        </MyButton>
        {showReset && (
          <MyButton type="secondary" onClick={handleReset} style={{ marginLeft: 8 }}>
            重置
          </MyButton>
        )}
      </div>
    </Form>
  );
};

export default MyForm;
```

```less
// components/MyForm/MyForm.less
.my-form {
  width: 100%;
  box-sizing: border-box;

  &__items {
    margin-bottom: 24px;
  }

  &-item {
    margin-bottom: 16px;

    &--8 {
      width: 33.333%;
      display: inline-block;
      margin-right: 16px;
    }

    &--12 {
      width: 50%;
      display: inline-block;
      margin-right: 16px;
    }

    &--24 {
      width: 100%;
      display: block;
    }
  }

  &__actions {
    margin-top: 16px;
    display: flex;
    align-items: center;
  }
}
```

## 3.3 使用示例
```tsx
import MyForm from ''./components/MyForm/MyForm'';
import { Input } from ''antd'';

const App = () => {
  // 表单项配置
  const formItems = [
    {
      name: ''username'',
      type: ''input'',
      label: ''用户名'',
      placeholder: ''请输入用户名'',
      rules: [{ required: true, message: ''请输入用户名'' }],
      span: 12,
    },
    {
      name: ''password'',
      type: ''input'',
      label: ''密码'',
      placeholder: ''请输入密码'',
      rules: [{ required: true, message: ''请输入密码'' }],
      props: { type: ''password'' },
      span: 12,
    },
    {
      name: ''age'',
      type: ''inputNumber'',
      label: ''年龄'',
      placeholder: ''请输入年龄'',
      rules: [{ type: ''number'', min: 0, max: 150, message: ''年龄需在 0-150 之间'' }],
      span: 8,
    },
    {
      name: ''gender'',
      type: ''select'',
      label: ''性别'',
      placeholder: ''请选择性别'',
      options: [
        { label: ''男'', value: ''male'' },
        { label: ''女'', value: ''female'' },
      ],
      span: 8,
    },
    {
      name: ''agree'',
      type: ''checkbox'',
      label: ''同意用户协议'',
      rules: [{ required: true, message: ''请同意用户协议'' }],
    },
    {
      name: ''custom'',
      type: ''cus...', '7fccb039-1e39-4894-ba93-5568169fef6e', 'true', '2025-12-22 03:21:26.646609+00', '2025-12-23 14:14:50.685922+00'), ('35c6fe2d-a642-46cd-99b0-8d048a40e792', '跨层级传参——useContext', '当组件层级较深（如爷爷组件 → 父组件 → 子组件 → 孙组件），若通过 `props` 逐层传递数据，会产生“props 透传”问题（中间组件无需使用该数据，却必须中转传递），代码冗余且维护成本高。React 提供 **Context 上下文** 解决跨层级传参问题，允许数据直接在组件树中“穿透”传递，无需逐层手动传递。

# 1. Context 核心概念
Context 本质是一个“数据容器”，可以存储需要共享的数据（如用户信息、主题配置、权限状态），并允许组件树中的任意子组件（无论层级多深）直接访问该数据，无需通过 props 透传。

## 1.1 关键 API
- `React.createContext(defaultValue)`：创建一个 Context 对象，`defaultValue` 是默认值（仅当子组件没有匹配的 Provider 时生效）。
- `Context.Provider`：提供数据的“生产者”组件，通过 `value` 属性传递数据，包裹需要共享数据的组件树。
- `useContext(Context)`：函数组件中获取 Context 数据的 Hook（React 16.8+），替代老版本的 `Context.Consumer`。
- `Context.Consumer`：类组件或函数组件中获取 Context 数据的组件形式（兼容老写法）。

# 2. Context 基本使用流程（函数组件 + useContext）
## 2.1 步骤 1：创建 Context 对象
单独创建一个 Context 文件（如 `ThemeContext.js`），集中管理 Context 相关逻辑，便于复用和维护：
```jsx
// ThemeContext.js
import { createContext } from ''react'';

// 创建 Context，默认值为 { theme: ''light'', toggleTheme: () => {} }
const ThemeContext = createContext({
  theme: ''light'',
  toggleTheme: () => {}
});

export default ThemeContext;
```

## 2.2 步骤 2：使用 Provider 提供数据
在组件树的**顶层组件**（如 App 组件、爷爷组件）中，使用 `Context.Provider` 包裹子组件，并通过 `value` 属性传递需要共享的数据（可包含状态和方法）：
```jsx
// 顶层组件 App.jsx
import { useState } from ''react'';
import ThemeContext from ''./ThemeContext'';
import Parent from ''./Parent''; // 中间组件（无需透传数据）

function App() {
  // 共享的状态和方法
  const [theme, setTheme] = useState(''light''); // 主题状态（light/dark）
  const toggleTheme = () => {
    setTheme(prev => prev === ''light'' ? ''dark'' : ''light'');
  };

  return (
    // Provider 包裹需要共享数据的组件树
    <ThemeContext.Provider value={{ theme, toggleTheme }}>
      <h1>当前主题：{theme}</h1>
      <Parent /> {/* 中间组件，无需传递 theme 和 toggleTheme */}
    </ThemeContext.Provider>
  );
}
```

## 2.3 步骤 3：子组件获取 Context 数据
无论子组件层级多深（如 Parent → Child → GrandChild），都可通过 `useContext` Hook 直接获取 Context 中的数据，无需通过 props 中转：
```jsx
// 中间组件 Parent.jsx（无需使用共享数据，仅作为容器）
import Child from ''./Child'';

function Parent() {
  // 无需接收和传递 theme 相关数据，直接渲染子组件
  return (
    <div>
      <h2>父组件（中间层）</h2>
      <Child />
    </div>
  );
}

// 子组件 Child.jsx（可直接获取 Context 数据）
import GrandChild from ''./GrandChild'';

function Child() {
  return (
    <div>
      <h3>子组件（中间层）</h3>
      <GrandChild />
    </div>
  );
}

// 孙组件 GrandChild.jsx（跨层级获取数据）
import { useContext } from ''react'';
import ThemeContext from ''./ThemeContext'';

function GrandChild() {
  // 通过 useContext 直接获取 Context 中的数据
  const { theme, toggleTheme } = useContext(ThemeContext);

  return (
    <div style={{ background: theme === ''light'' ? ''#fff'' : ''#333'', color: theme === ''light'' ? ''#333'' : ''#fff'' }}>
      <h4>孙组件（层级最深）</h4>
      <p>当前主题：{theme}</p>
      <button onClick={toggleTheme}>切换主题</button>
    </div>
  );
}
```

# 3. 类组件中使用 Context
类组件无法使用 `useContext` Hook，需通过 `Context.Consumer` 组件或 `static contextType` 属性获取 Context 数据。

## 方式 1：Context.Consumer 组件（推荐，支持多个 Context）
`Consumer` 组件的 `children` 是一个函数，接收 Context 的 `value` 作为参数，返回 JSX 结构：
```jsx
// 类组件中使用 Context.Consumer
import ThemeContext from ''./ThemeContext'';
import React from ''react'';

class ClassChild extends React.Component {
  render() {
    return (
      <ThemeContext.Consumer>
        {/* 函数参数为 Context 的 value */}
        {({ theme, toggleTheme }) => (
          <div style={{ background: theme === ''light'' ? ''#fff'' : ''#333'' }}>
            <p>类组件 - 当前主题：{theme}</p>
            <button onClick={toggleTheme}>切换主题</button>
          </div>
        )}
      </ThemeContext.Consumer>
    );
  }
}
```

## 方式 2：static contextType 属性（仅支持单个 Context）
通过类的静态属性 `contextType` 关联 Context，然后通过 `this.context` 获取数据：
```jsx
import ThemeContext from ''./ThemeContext'';
import React from ''react'';

class ClassChild extends React.Component {
  // 关联 Context
  static contextType = ThemeContext;

  render() {
    // 通过 this.context 获取数据
    const { theme, toggleTheme } = this.context;
    return (
      <div>
        <p>类组件 - 当前主题：{theme}</p>
        <button onClick={toggleTheme}>切换主题</button>
      </div>
    );
  }
}
```

# 4. 多个 Context 联合使用
实际开发中可能需要共享多种类型的数据（如主题、用户信息），可创建多个 Context 并嵌套使用 `Provider`，子组件通过 `useContext` 分别获取：
```jsx
// 1. 创建两个独立的 Context
const ThemeContext = createContext(''light'');
const UserContext = createContext({ name: ''匿名用户'' });

// 2. 顶层组件嵌套 Provider
function App() {
  const user = { name: ''React 开发者'', role: ''admin'' };
  return (
    <UserContext.Provider value={user}>
      <ThemeContext.Provider value="dark">
        <Parent />
      </ThemeContext.Provider>
    </UserContext.Provider>
  );
}

// 3. 子组件分别获取多个 Context
function GrandChild() {
  const user = useContext(UserContext);
  const theme = useContext(ThemeContext);

  return (
    <div>
      <p>用户名：{user.name}</p>
      <p>主题：{theme}</p>
    </div>
  );
}
```

# 5. Context 注意事项
## 5.1 避免过度使用 Context
Context 适用于**全局共享数据**（如主题、用户信息、权限配置），若仅用于少数组件的局部通信，优先使用 props 或回调函数，避免 Context 滥用导致组件耦合度升高。

## 5.2 Provider 的 value 变化触发重新渲染
当 `Context.Provider` 的 `value` 属性变化时（引用变化，如对象、数组重新创建），所有消费该 Context 的子组件都会重新渲染。优化方案：
- 用 `useState` 或 `useReducer` 管理 `value` 中的状态（保证状态更新时引用变化）。
- 若 `value` 是对象，避免直接在 `Provider` 中创建新对象（导致每次渲染都触发子组件更新），可通过 `useMemo` 缓存：
```jsx
// 优化：用 useMemo 缓存 value 对象，仅当依赖变化时更新
const value = useMemo(() => ({
  theme,
  toggleTheme
}), [theme]); // 仅 theme 变化时，value 引用才变化

return <ThemeContext.Provider value={value}>{/* 子组件 */}</ThemeContext.Provider>;
```

## 5.3 defaultValue 的生效条件
`createContext(defaultValue)` 中的默认值，仅当子组件**没有找到匹配的 Provider** 时才会生效，若存在 Provider，即使 Provider 的 `value` 为 `undefined`，也不会使用默认值：
```jsx
const ThemeContext = createContext(''light'');

// 场景 1：没有 Provider，使用默认值 ''light''
function NoProviderChild() {
  const theme = useContext(ThemeContext);
  console.log(theme); // ''light''
}

// 场景 2：有 Provider 但 value 为 undefined，不使用默认值
function HasProviderChild() {
  return (
    <ThemeContext.Provider value={undefined}>
      <Child /> {/* 子组件获取到的 theme 是 undefined */}
    </ThemeContext.Provider>
  );
}
```

## 5.4 Context 与性能优化
若消费 Context 的子组件是纯组件（如 `React.memo` 包装的函数组件、`PureComponent` 类组件），当 `value` 变化时仍会重新渲染（因为 `value` 是对象/数组时引用变化）。若需进一步优化，可将 Context 拆分为多个独立的 Context，让组件只消费需要的数据，减少不必要的渲染。

# 6. 核心总结
1. **核心作用**：解决跨层级组件传参问题，避免 props 透传。
2. **核心 API**：`createContext`（创建 Context）、`Context.Provider`（提供数据）、`useContext`（函数组件获取数据）。
3. **使用流程**：创建 Context → 顶层组件用 Provider 提供数据 → 深层子组件用 useContext 消费数据。
4. **注意事项**：避免过度使用、缓存 Provider 的 value 避免不必要渲染、默认值仅在无 Provider 时生效。
5. **适用场景**：全局共享数据（主题、用户信息、权限）、多层级组件通信。', '803ada09-ee46-463c-b7f3-403560bfc20b', 'true', '2025-12-19 11:05:48.570434+00', '2025-12-19 11:05:48.570434+00'), ('3d5fbcf7-8bd8-4214-a318-2492f7b7db49', 'Redux 核心概念', 'Redux 是一款专为 JavaScript 应用设计的**状态管理库**，核心目标是实现应用状态的集中式管理，保证状态变化可预测、可追踪。其核心设计围绕四个关键概念展开：

# 1. Store（状态容器）
Store 是 Redux 应用的“心脏”，是**唯一的全局状态容器**，负责存储整个应用的所有共享状态（state）。一个 Redux 应用只能有一个根 Store，避免状态分散导致的管理混乱。

## 1.1 核心特性
- 存储完整的应用状态树（state tree）；
- 提供 `getState()` 方法获取当前状态；
- 提供 `dispatch(action)` 方法触发状态更新；
- 提供 `subscribe(listener)` 方法监听状态变化；
- 状态只能通过 Redux 规定的流程修改，无法直接修改（单向数据流核心）。

## 1.2 简单示例（创建 Store）
```javascript
import { createStore } from ''redux'';
import rootReducer from ''./reducers'';

// 创建 Store，传入根 Reducer
const store = createStore(rootReducer);

// 获取当前状态
console.log(store.getState()); // 初始状态
```

# 2. Action（状态变更指令）
Action 是描述“状态要如何变更”的**纯对象**，是触发状态更新的唯一方式。它必须包含 `type` 字段（字符串类型，标识动作类型），可选包含 `payload` 字段（携带状态变更所需的数据）。

## 2.1 核心规则
- Action 是普通 JavaScript 对象，不可变；
- `type` 字段必须唯一，通常用常量定义（避免硬编码错误）；
- 仅描述“发生了什么”，不描述“如何改变状态”（状态修改逻辑由 Reducer 负责）。

## 2.2 示例
```javascript
// 定义 Action 类型常量
export const ADD_TODO = ''ADD_TODO'';
export const DELETE_TODO = ''DELETE_TODO'';

// 创建 Action 创建函数（返回 Action 对象的函数，简化调用）
export const addTodo = (text) => ({
  type: ADD_TODO,
  payload: { text, id: Date.now() } // 携带待办事项文本和唯一 ID
});

export const deleteTodo = (id) => ({
  type: DELETE_TODO,
  payload: { id }
});
```

# 3. Reducer（状态修改逻辑）
Reducer 是**纯函数**，负责根据接收到的 Action，计算并返回新的状态。它接收两个参数：`state`（当前状态）和 `action`（触发的动作），返回新的状态对象（不可直接修改原状态）。

## 3.1 核心规则（纯函数要求）
- 相同输入必须返回相同输出（无随机值、无异步操作）；
- 不修改原状态（需返回新对象，如使用扩展运算符、Object.assign）；
- 无副作用（不调用 API、不修改 DOM、不读写本地存储）。

## 3.2 示例（单个 Reducer）
```javascript
import { ADD_TODO, DELETE_TODO } from ''./actions'';

// 初始状态
const initialState = {
  todos: []
};

// Todo Reducer
const todoReducer = (state = initialState, action) => {
  switch (action.type) {
    case ADD_TODO:
      // 返回新状态，不修改原 state
      return {
        ...state,
        todos: [...state.todos, action.payload]
      };
    case DELETE_TODO:
      return {
        ...state,
        todos: state.todos.filter(todo => todo.id !== action.payload.id)
      };
    default:
      // 未匹配到 Action 时返回原状态
      return state;
  }
};

export default todoReducer;
```

## 3.3 根 Reducer（组合多个 Reducer）
当应用状态复杂时，可将状态按模块拆分（如 todo、user），每个模块对应一个 Reducer，再通过 `combineReducers` 组合为根 Reducer：
```javascript
import { combineReducers } from ''redux'';
import todoReducer from ''./todoReducer'';
import userReducer from ''./userReducer'';

// 根 Reducer，key 对应状态树的属性名
const rootReducer = combineReducers({
  todos: todoReducer,
  user: userReducer
});

export default rootReducer;
```

# 4. 单向数据流（核心流程）
Redux 严格遵循**单向数据流**原则，确保状态变化可追踪、可预测，核心流程如下：
1. **组件触发 Action**：组件通过 `store.dispatch(action)` 发送动作（如用户点击“添加待办”按钮）；
2. **Store 调用 Reducer**：Store 接收到 Action 后，将当前状态和 Action 传入 Reducer；
3. **Reducer 计算新状态**：Reducer 根据 Action 类型处理状态，返回新状态；
4. **Store 更新状态**：Store 用 Reducer 返回的新状态替换旧状态；
5. **组件感知状态变化**：订阅了 Store 的组件收到通知，重新获取状态并更新视图。

## 流程图解
`组件 → dispatch(Action) → Store → Reducer(计算新状态) → Store 更新 → 组件重新渲染`', 'a3109983-f66b-42c0-afb5-8d07e97cbc4e', 'true', '2025-12-22 03:11:25.300818+00', '2025-12-23 03:23:17.603837+00'), ('3deaebda-342d-4837-a3fb-29d60b5acd37', 'React DevTools 调试技巧', '# 1. React DevTools 基础介绍
React DevTools 是 React 官方提供的调试工具，支持 Chrome/Firefox 浏览器扩展、React Native 调试，核心功能包括：
- 组件层级可视化：查看组件树结构、props/state 数据；
- 性能分析：定位渲染瓶颈、不必要的重渲染；
- 组件交互调试：修改 props/state 实时预览效果；
- Hook 调试：追踪 useState/useEffect/useContext 等 Hook 执行过程。

# 2. 安装与配置
## 2.1 浏览器扩展安装
- Chrome：Chrome 网上应用店搜索「React Developer Tools」安装；
- Firefox：Firefox 附加组件商店搜索「React Developer Tools」安装；
- 本地开发（无网络）：下载扩展包手动安装（Chrome 开发者模式加载已解压的扩展程序）。

## 2.2 React Native 配置
```bash
npm install --save-dev react-devtools # 安装依赖
npx react-devtools # 启动调试工具
import ReactDevTools from ''react-devtools''; # 项目中集成（可选）
if (process.env.NODE_ENV === ''development'') {
  ReactDevTools.connect();
}
```

# 3. 核心功能与调试技巧
## 3.1 组件检查器（Components 面板）
### 3.1.1 查看组件树与数据
- 左侧面板：展示组件层级结构（函数组件显示 `ƒ ComponentName`，类组件显示 `ClassComponent`）；
- 右侧面板：
  - **Props**：查看组件接收的 props（包括父组件传递、默认 props）；
  - **State & Hooks**：查看组件内部 state、useState/useReducer 存储的数据；
  - **Context**：查看组件订阅的 Context 数据；
  - **HOCs**：穿透高阶组件（如 `withRouter`/`connect`）查看原始组件。

### 3.1.2 实时修改数据
- 点击 props/state 数值可直接编辑（支持字符串、数字、布尔值、对象）；
- 示例：修改 `count` 状态为 10，组件会立即重新渲染，验证边界条件逻辑。

### 3.1.3 组件筛选与搜索
- 顶部搜索框输入组件名，快速定位目标组件；
- 右键组件选择「Show in DOM」，跳转到浏览器元素面板对应的 DOM 节点。

###3.1.4  组件标签与备注
- 右键组件选择「Add tag」，添加自定义标签（如「性能问题组件」），便于团队协作调试。

## 3.2 性能分析（Profiler 面板）
### 3.2.1 录制渲染过程
- 点击「Record」按钮，触发组件交互（如点击按钮、输入内容），停止录制后生成性能报告；
- 报告核心指标：
  - **渲染时间**：组件渲染耗时（毫秒）；
  - **渲染原因**：触发重渲染的因素（props 变化、state 变化、Context 变化）；
  - **组件层级**：渲染链路上的所有组件。

### 3.2.2 定位重渲染问题
- 筛选「Wasted time」列（不必要的重渲染耗时），数值越高说明优化空间越大；
- 示例：父组件更新导致子组件无意义重渲染，可通过 `React.memo`/`useMemo`/`useCallback` 优化。

### 3.2.3 火焰图与排名图
- **火焰图**：展示组件渲染顺序与耗时占比（横向越长，耗时越久）；
- **排名图**：按渲染耗时从高到低排序组件，快速定位性能瓶颈。

## 3.3 Hook 调试技巧
### 3.3.1 useEffect 依赖追踪
- 组件面板中展开 `useEffect` Hook，查看「Deps」依赖项列表；
- 若依赖项频繁变化（如每次渲染生成新对象），会导致 useEffect 重复执行，可通过 `useMemo` 缓存依赖项。

### 3.3.2 useContext 订阅追踪
- 查看组件订阅的 Context 数据，确认是否因 Context 频繁更新导致组件重渲染；
- 优化方案：拆分 Context，避免无关数据共享。

### 3.3.3 自定义 Hook 调试
- 自定义 Hook 内部的 state/hooks 会显示在组件的「State & Hooks」面板中，命名建议前缀为 `use`（如 `useUser`），便于识别。

## 3.4 高级调试技巧
### 3.4.1 禁用 React 缓存（Strict Mode）
- 开启 React 严格模式（`<React.StrictMode>`），DevTools 会强制组件重复渲染（模拟挂载/卸载），暴露潜在的副作用问题（如未清理的定时器）。

### 3.4.2 组件快照对比
- 右键组件选择「Take snapshot」，修改数据后再次快照，对比两次快照的 props/state 差异，定位数据变化原因。

### 3.4.3 性能警告排查
- 控制台中关注 React DevTools 输出的警告（如「Missing key prop」「Invalid hook call」），及时修复避免隐藏问题。

# 4. 常见问题解决
## 4.1 DevTools 不显示组件树
- 确认项目使用 React 16.8+ 版本；
- 检查是否开启生产环境构建（`process.env.NODE_ENV === ''production''` 会隐藏 DevTools）；
- 确保页面中只有一个 React 版本（多版本冲突会导致 DevTools 失效）。

## 4.2 Profiler 无数据
- 确认组件使用 React 16.9+ 版本；
- 检查是否在严格模式下录制（部分旧版本 React 存在兼容性问题）；
- 确保录制过程中触发了组件渲染（如点击按钮修改 state）。

## 4.3 无法修改 props/state
- 生产环境构建的项目不支持修改数据（DevTools 只读）；
- 类组件的 state 若为不可变对象（如冻结的 Object.freeze），无法直接编辑。

# 5. 最佳实践
1. 开发环境强制开启 React 严格模式，提前暴露副作用问题；
2. 定期使用 Profiler 分析关键页面（如首页、列表页），优化重渲染耗时；
3. 团队协作时，通过组件标签标注调试要点，提高沟通效率；
4. 结合浏览器「Performance」面板，分析 React 渲染与 DOM 绘制的整体性能。', 'ac88594f-879e-410b-94ce-266d80cce0f4', 'true', '2025-12-22 03:21:56.975556+00', '2025-12-23 14:28:13.515961+00'), ('4222d782-422a-43de-b53b-4f3c6dc29b69', 'React 项目目录结构解析', '以 Create React App（CRA）和 Vite 创建的 React 项目为例，解析核心目录和文件的作用（聚焦开发中常用文件，忽略依赖和配置细节）。

# 1. Create React App（CRA）项目结构
```
react-demo/
├── node_modules/       # 项目依赖包（npm install 安装，无需修改）
├── public/             # 静态资源目录（不会被 Webpack 打包）
│   ├── favicon.ico     # 网站图标
│   ├── index.html      # 入口 HTML 文件（React 渲染的根容器）
│   └── manifest.json   # PWA 配置文件（可选， Progressive Web App）
├── src/                # 源代码目录（核心开发目录）
│   ├── App.css         # App 组件的样式文件
│   ├── App.js          # 根组件（整个应用的入口组件）
│   ├── App.test.js     # App 组件的测试文件（可选，可删除）
│   ├── index.css       # 全局样式文件（作用于整个应用）
│   ├── index.js        # 入口 JavaScript 文件（启动 React 应用）
│   ├── logo.svg        # React 默认图标（可删除）
│   └── reportWebVitals.js  # 性能监控文件（可选，可删除）
├── .gitignore          # Git 忽略文件（指定不提交到 Git 的文件）
├── package.json        # 项目配置文件（依赖、脚本命令等）
├── package-lock.json   # 依赖版本锁定文件（确保依赖一致性）
└── README.md           # 项目说明文档
```

# 2. Vite + React 项目结构
```
react-vite-demo/
├── node_modules/       # 项目依赖包（无需修改）
├── public/             # 静态资源目录（不会被 Vite 处理，原样输出）
│   ├── favicon.ico     # 网站图标
│   └── robots.txt      # 搜索引擎爬虫配置（可选）
├── src/                # 源代码目录（核心开发目录）
│   ├── App.css         # App 组件的样式文件
│   ├── App.jsx         # 根组件（JSX 后缀，与 JS 功能一致，推荐使用）
│   ├── index.css       # 全局样式文件
│   ├── main.jsx        # 入口 JavaScript 文件（启动 React 应用）
│   └── vite-env.d.ts   # Vite 类型声明文件（TS 项目必备，JS 项目可忽略）
├── .gitignore          # Git 忽略文件
├── index.html          # 入口 HTML 文件（与 CRA 不同，在根目录）
├── package.json        # 项目配置文件
├── package-lock.json   # 依赖版本锁定文件
├── tsconfig.json       # TypeScript 配置文件（TS 项目才有）
└── vite.config.js      # Vite 配置文件（可自定义构建规则）
```

# 3. 核心文件详解（重点关注）
## 3.1 入口 HTML 文件
- CRA 中：`public/index.html`；Vite 中：`index.html`。
- 核心作用：提供 React 渲染的根容器，代码关键部分：
  ```html
  React 会将组件渲染到这个 div 中 -->
  root"> ```
- 注意：无需在 HTML 中引入 JS 文件，CRA/Vite 会自动注入打包后的脚本。

## 3.2 入口 JS/JSX 文件
- CRA 中：`src/index.js`；Vite 中：`src/main.jsx`。
- 核心作用：初始化 React 应用，将根组件渲染到根容器中。
  - CRA 示例（`index.js`）：
    ```jsx
    import React from ''react'';
    import ReactDOM from ''react-dom/client'';  // React 18+ 渲染 API
    import ''./index.css'';  // 引入全局样式
    import App from ''./App'';  // 引入根组件

    // 获取根容器，创建 React 根实例
    const root = ReactDOM.createRoot(document.getElementById(''root''));
    // 渲染根组件 App 到根容器
    root.render(
      Mode>  {/* 严格模式：检测代码潜在问题，开发环境有效 */}
              >
    );
    ```
  - Vite 示例（`main.jsx`）：
    ```jsx
    import React from ''react'';
    import ReactDOM from ''react-dom/client'';
    import ''./index.css'';
    import App from ''./App.jsx'';

    ReactDOM.createRoot(document.getElementById(''root'')).render(
      
              >
    );
    ```

## 3.3 根组件：App.js / App.jsx
- 整个应用的顶层组件，所有页面和功能组件都嵌套在 App 组件中。
- 示例（`App.jsx`）：
  ```jsx
  import ''./App.css'';

  function App() {
    // 组件返回 JSX 语法描述 UI 结构
    return (
      ">
        >Hello React!>
        这是我的第一个 React 应用 
  }

  export default App;  // 导出组件，供入口文件引入
  ```

## 3.4 样式文件：index.css / App.css
- `index.css`：全局样式，作用于整个应用（如重置样式、全局字体等）。
- `App.css`：组件局部样式，仅作用于 App 组件（后续可通过 CSS Modules、Styled Components 等实现样式隔离）。

## 3.5 配置文件
- `package.json`：核心配置文件，包含项目名称、依赖包、脚本命令（如 `npm start` 对应 `react-scripts start`）。
- `vite.config.js`（Vite 项目）：自定义 Vite 配置（如修改端口、配置代理、引入插件等）。

# 4. 开发规范建议
1. 新增组件：在 `src` 目录下创建 `components` 文件夹，按组件功能分类（如 `src/components/Button`、`src/components/Navbar`），每个组件单独创建文件夹（包含组件文件、样式文件）。
2. 静态资源：图片、字体等资源建议放在 `src/assets` 文件夹（CRA/Vite 均支持），便于统一管理。
3. 样式管理：小型项目可使用普通 CSS，中大型项目推荐使用 CSS Modules（样式隔离）、Tailwind CSS（原子化样式）或 Styled Components（CSS-in-JS）。
', '885129c3-bae4-445c-979c-09863b3895f8', 'true', '2025-12-19 06:52:43.918673+00', '2025-12-19 09:15:44.114234+00'), ('43f6434a-7b32-4b2c-b70f-e6ad9edfd997', '非受控表单', '# 1. 非受控表单的核心概念
**非受控表单**是指表单元素的值不由 React 状态控制，而是由 DOM 自身维护，组件通过 `ref` 直接访问 DOM 元素获取值。这种模式更接近原生 HTML 表单的行为，适用于简单表单场景，代码更简洁。

## 核心特征
- 表单元素的值由 DOM 自身管理，无需绑定 `state`；
- 通过 `ref` 引用表单元素，在需要时（如提交表单）获取值；
- 可通过 `defaultValue`/`defaultChecked` 设置默认值（仅初始化时生效）；
- 无需 `onChange` 事件同步状态，减少代码量。

# 2. 非受控表单的实现（useRef）
React 中通过 `useRef` Hook 创建 `ref` 对象，绑定到表单元素，再通过 `ref.current` 访问 DOM 元素及其 `value`/`checked` 属性。

## 2.1 基础示例：文本输入框与密码框
```javascript
import { useRef } from ''react'';

function UncontrolledBasicForm() {
  // 创建 ref 引用表单元素
  const usernameRef = useRef(null);
  const passwordRef = useRef(null);

  const handleSubmit = (e) => {
    e.preventDefault(); // 阻止默认提交

    // 通过 ref 获取表单值（需判断元素是否存在）
    const username = usernameRef.current?.value || '''';
    const password = passwordRef.current?.value || '''';

    console.log(''提交数据：'', { username, password });

    // 可选：提交后重置表单
    usernameRef.current.value = '''';
    passwordRef.current.value = '''';
  };

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <label>用户名：</label>
        {/* ref 绑定到表单元素，defaultValue 设置默认值 */}
        <input
          type="text"
          ref={usernameRef}
          defaultValue="" // 仅初始化生效，后续修改需操作 DOM
          placeholder="请输入用户名"
        />
      </div>
      <div>
        <label>密码：</label>
        <input
          type="password"
          ref={passwordRef}
          defaultValue=""
          placeholder="请输入密码"
        />
      </div>
      <button type="submit">提交</button>
    </form>
  );
}
```

## 2.2 单选按钮与复选框
### 场景 1：单选按钮（defaultChecked 设置默认选中）
```javascript
function UncontrolledRadio() {
  const genderRef = useRef(null); // 引用单选组中的第一个元素（或任意一个）

  const handleSubmit = (e) => {
    e.preventDefault();
    // 获取选中的单选按钮值（通过 name 分组查询）
    const selectedGender = document.querySelector(''input[name="gender"]:checked'')?.value || '''';
    console.log(''选择的性别：'', selectedGender);
  };

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <label>性别：</label>
        <input
          type="radio"
          name="gender"
          value="male"
          defaultChecked // 默认选中
          ref={genderRef}
        />
        <span>男</span>
        <input
          type="radio"
          name="gender"
          value="female"
        />
        <span>女</span>
      </div>
      <button type="submit">提交</button>
    </form>
  );
}
```

### 场景 2：复选框（单个/多个）
```javascript
function UncontrolledCheckbox() {
  // 单个复选框 ref
  const agreeRef = useRef(null);
  // 多个复选框（通过类名或 name 统一获取）

  const handleSubmit = (e) => {
    e.preventDefault();

    // 单个复选框：获取 checked 属性
    const isAgreed = agreeRef.current?.checked || false;

    // 多个复选框：通过 name 查询所有选中的元素
    const selectedHobbies = Array.from(
      document.querySelectorAll(''input[name="hobby"]:checked'')
    ).map(input => input.value);

    console.log(''是否同意协议：'', isAgreed);
    console.log(''选择的兴趣：'', selectedHobbies);
  };

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <input
          type="checkbox"
          id="agree"
          ref={agreeRef}
          defaultChecked={false}
        />
        <label htmlFor="agree">同意协议</label>
      </div>
      <div>
        <label>兴趣爱好：</label>
        <input type="checkbox" name="hobby" value="sports" />
        <span>运动</span>
        <input type="checkbox" name="hobby" value="reading" />
        <span>阅读</span>
        <input type="checkbox" name="hobby" value="coding" />
        <span>编程</span>
      </div>
      <button type="submit">提交</button>
    </form>
  );
}
```

## 2.3 下拉选择框（select）
```javascript
function UncontrolledSelect() {
  const cityRef = useRef(null);

  const handleSubmit = (e) => {
    e.preventDefault();
    // 获取选中值
    const selectedCity = cityRef.current?.value || '''';
    console.log(''选择的城市：'', selectedCity);
  };

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <label>城市：</label>
        <select ref={cityRef} defaultValue="beijing">
          <option value="beijing">北京</option>
          <option value="shanghai">上海</option>
          <option value="guangzhou">广州</option>
        </select>
      </div>
      <button type="submit">提交</button>
    </form>
  );
}
```

## 2.4 复杂非受控表单（多字段统一处理）
通过多个 `ref` 引用不同字段，或通过 `form` 元素的 `elements` 属性批量获取字段值。

```javascript
import { useRef } from ''react'';

function UncontrolledComplexForm() {
  // 引用整个表单元素
  const formRef = useRef(null);

  const handleSubmit = (e) => {
    e.preventDefault();
    const form = formRef.current;

    // 通过 form.elements 获取所有字段值（按 name 属性匹配）
    const username = form.username.value;
    const password = form.password.value;
    const gender = form.gender.value;
    const isAgreed = form.agree.checked;
    const selectedHobbies = Array.from(form.hobby)
      .filter(input => input.checked)
      .map(input => input.value);
    const city = form.city.value;
    const intro = form.intro.value;

    console.log(''提交数据：'', {
      username,
      password,
      gender,
      isAgreed,
      selectedHobbies,
      city,
      intro
    });

    // 表单重置（原生 form 元素的 reset 方法）
    form.reset();
  };

  return (
    <form ref={formRef} onSubmit={handleSubmit} style={{ display: ''flex'', flexDirection: ''column'', gap: ''10px'' }}>
      <div>
        <label>用户名：</label>
        <input type="text" name="username" defaultValue="" placeholder="请输入用户名" />
      </div>
      <div>
        <label>密码：</label>
        <input type="password" name="password" defaultValue="" placeholder="请输入密码" />
      </div>
      <div>
        <label>性别：</label>
        <input type="radio" name="gender" value="male" defaultChecked /> 男
        <input type="radio" name="gender" value="female" /> 女
      </div>
      <div>
        <input type="checkbox" name="agree" id="agree" defaultChecked={false} />
        <label htmlFor="agree">同意协议</label>
      </div>
      <div>
        <label>兴趣爱好：</label>
        <input type="checkbox" name="hobby" value="sports" /> 运动
        <input type="checkbox" name="hobby" value="reading" /> 阅读
        <input type="checkbox" name="hobby" value="coding" /> 编程
      </div>
      <div>
        <label>城市：</label>
        <select name="city" defaultValue="beijing">
          <option value="beijing">北京</option>
          <option value="shanghai">上海</option>
        </select>
      </div>
      <div>
        <label>个人简介：</label>
        <textarea name="intro" defaultValue="" style={{ width: ''300px'', height: ''100px'' }} />
      </div>
      <button type="submit">提交</button>
    </form>
  );
}
```

# 3. 非受控表单的优势与适用场景
## 3.1 优势
- 代码简洁：无需维护 `state` 和 `onChange` 事件，减少模板代码；
- 原生行为：更接近原生 HTML 表单，学习成本低；
- 性能优化：避免因表单频繁变化导致的组件重渲染；
- 批量处理：可通过 `form.elements` 批量获取字段值，简化提交逻辑。

## 3.2 适用场景
- 简单表单：如登录框、搜索框等字段较少的场景；
- 原生交互：需要使用原生表单特性（如 `form.reset()`）的场景；
- 性能敏感：表单字段极多，频繁重渲染会影响性能的场景；
- 第三方集成：与非 React 表单库（如原生插件）集成的场景。

# 4. 注意事项
- 无法实时响应：若需实时验证、格式转换等功能，非受控表单需手动监听 `onChange` 事件，失去简洁性；
- 默认值仅初始化：`defaultValue`/`defaultChecked` 仅在组件挂载时生效，后续修改需通过 DOM 操作；
- 需处理 DOM 兼容性：直接操作 DOM 可能存在浏览器兼容性问题，需谨慎；
- 无障碍适配：需手动设置 `name`、`id`、`label` 关联，确保无障碍访问；
- 避免滥用：复杂表单场景（如多步骤表单、动态字段）建议使用受控表单，便于维护。
', '0e360aa6-df1e-4212-b06e-7ebc4541f5d5', 'true', '2025-12-22 03:18:36.862956+00', '2025-12-23 13:01:40.998356+00'), ('4632631e-8b5a-4e18-a452-027fe9cf187c', '条件渲染与列表渲染', '在 React 开发中，**条件渲染**和**列表渲染**是构建动态 UI 的基础能力。条件渲染用于根据不同状态显示不同的 UI 内容，列表渲染用于批量展示结构化数据，而 `key` 属性则是列表渲染中保证性能和正确性的关键。

# 1. 条件渲染
条件渲染的核心思想是：**根据组件的 state 或 props 动态决定渲染的内容**。React 中的条件渲染和 JavaScript 中的条件判断逻辑完全一致，我们可以使用 `if-else`、三元运算符、逻辑与运算符等方式实现。

## 方式1：if-else 条件判断
适用于**复杂的多分支条件**场景，根据不同的条件返回不同的 React 元素。
```jsx
import { useState } from ''react'';

function LoginStatus() {
  const [isLogin, setIsLogin] = useState(false);

  // 定义登录/未登录状态的渲染内容
  if (isLogin) {
    return <div>欢迎回来！<button onClick={() => setIsLogin(false)}>退出登录</button></div>;
  } else {
    return <div>请先登录！<button onClick={() => setIsLogin(true)}>登录</button></div>;
  }
}
```
这种方式逻辑清晰，适合条件分支较多的情况。

## 方式2：三元运算符
适用于**简单的二选一**场景，写法简洁，直接嵌入到 JSX 中。
```jsx
function LoginStatus() {
  const [isLogin, setIsLogin] = useState(false);

  return (
    <div>
      {isLogin ? (
        <div>欢迎回来！<button onClick={() => setIsLogin(false)}>退出登录</button></div>
      ) : (
        <div>请先登录！<button onClick={() => setIsLogin(true)}>登录</button></div>
      )}
    </div>
  );
}
```
三元运算符可以嵌套使用，但嵌套过深会降低代码可读性，建议配合函数拆分复杂逻辑。

## 方式3：逻辑与运算符（&&）
适用于**条件为真时渲染内容，条件为假时不渲染**的场景。
```jsx
function Notification() {
  const [hasMessage, setHasMessage] = useState(true);

  return (
    <div>
      <h2>消息通知</h2>
      {/* 当 hasMessage 为 true 时，渲染 <p> 标签；为 false 时，不渲染 */}
      {hasMessage && <p>你有一条新消息！</p>}
    </div>
  );
}
```
注意：如果左侧条件为**假值**（如 0、''''、null、undefined），React 会渲染该假值，因此需要确保左侧条件是布尔值。例如，避免直接使用 `{count && <p>计数：{count}</p>}`，当 `count` 为 0 时会渲染 0，应该改为 `{count > 0 && <p>计数：{count}</p>}`。

## 方式4：元素变量
可以将 React 元素赋值给变量，根据条件修改变量的值，再渲染变量。
```jsx
function RoleView() {
  const [role, setRole] = useState(''user'');
  let content;

  if (role === ''admin'') {
    content = <div>管理员：拥有所有权限</div>;
  } else if (role === ''user'') {
    content = <div>普通用户：拥有查看权限</div>;
  } else {
    content = <div>游客：请登录</div>;
  }

  return (
    <div>
      {content}
      <button onClick={() => setRole(''admin'')}>切换到管理员</button>
    </div>
  );
}
```

## 条件渲染的注意事项
1. **避免不必要的渲染**：可以通过 `React.memo` 包装组件，减少不必要的重渲染。
2. **不要在渲染函数中使用 return 之外的条件判断**：确保所有条件分支都有明确的返回值，避免出现 `undefined`。
3. **空渲染**：如果某个条件下不需要渲染任何内容，可以返回 `null`。
    ```jsx
    function EmptyComponent({ show }) {
      if (!show) return null;
      return <div>显示内容</div>;
    }
    ```

# 2. 列表渲染
当需要渲染一组相同结构的 UI 时，就需要用到列表渲染。React 中通常使用 `Array.prototype.map` 方法遍历数据数组，生成对应的 React 元素列表。

## 2.1 基本用法
`map` 方法会遍历数组中的每一项，返回一个新的 React 元素数组，然后将这个数组嵌入到 JSX 中渲染。
```jsx
import { useState } from ''react'';

function FruitList() {
  const [fruits] = useState([''苹果'', ''香蕉'', ''橙子'', ''葡萄'']);

  return (
    <ul>
      {fruits.map((fruit) => (
        <li>{fruit}</li>
      ))}
    </ul>
  );
}
```
运行这段代码，控制台会出现一个警告：`Warning: Each child in a list should have a unique "key" prop`。这是因为 React 需要通过 `key` 属性来识别列表中的每一项，保证列表更新时的性能和正确性。

# 3. key 的作用与原理
## 3.1 为什么需要 key
`key` 是 React 用于**标识列表项唯一性**的特殊属性，它的核心作用是帮助 React 的 Diff 算法快速识别列表中元素的**新增、删除、移动**操作，从而只更新变化的部分，提升渲染性能。

如果不设置 `key`，React 会默认使用列表项的**索引**作为 `key`，这在列表项顺序不变的情况下可以正常工作，但当列表项顺序发生变化（如排序、删除中间项）时，会导致 React 错误地更新 DOM，引发性能问题或 UI 异常。

## 3.2 key 的使用规则
1. **唯一性**：同一个列表中的 `key` 必须是唯一的，不能重复。
2. **稳定性**：`key` 应该是稳定不变的，不要使用随机数或索引作为 `key`（除非列表是静态的）。
3. **与数据关联**：最好使用数据本身的唯一标识作为 `key`，如数据库中的 ID。

示例：使用唯一 ID 作为 key
```jsx
function FruitList() {
  const [fruits] = useState([
    { id: 1, name: ''苹果'' },
    { id: 2, name: ''香蕉'' },
    { id: 3, name: ''橙子'' },
    { id: 4, name: ''葡萄'' }
  ]);

  return (
    <ul>
      {fruits.map((fruit) => (
        <li key={fruit.id}>{fruit.name}</li>
      ))}
    </ul>
  );
}
```

## 3.3 为什么不推荐使用索引作为 key
当列表项的顺序发生变化时，使用索引作为 `key` 会导致 React 无法正确识别列表项的变化。

示例：错误使用索引作为 key 的问题
```jsx
function TodoList() {
  const [todos, setTodos] = useState([
    { id: 1, text: ''学习 React'' },
    { id: 2, text: ''学习 Vue'' }
  ]);

  // 删除第一项
  const deleteFirst = () => {
    setTodos(todos.slice(1));
  };

  return (
    <div>
      <button onClick={deleteFirst}>删除第一项</button>
      <ul>
        {todos.map((todo, index) => (
          <li key={index}>{todo.text}</li>
        ))}
      </ul>
    </div>
  );
}
```
初始状态下，两个列表项的 `key` 分别是 0 和 1。当删除第一项后，剩下的列表项的 `key` 变为 0，React 会认为原来的第二项变成了第一项，从而**复用原来的 DOM 节点**，这在复杂组件中可能导致状态错乱。

如果使用 `todo.id` 作为 `key`，删除第一项后，剩下的列表项的 `key` 是 2，React 会正确识别到第一项被删除，直接移除对应的 DOM 节点。

## 3.4 key 的原理：React Diff 算法对 key 的处理
React 的 Diff 算法在处理列表时，会遵循以下逻辑：
1. **对比新旧列表的 key**：当列表更新时，React 会先对比新旧列表中具有相同 `key` 的元素。
2. **复用相同 key 的元素**：如果新旧列表中存在相同 `key` 的元素，React 会认为这是同一个元素，只更新其属性和子元素，而不会重新创建 DOM 节点。
3. **处理新增/删除的元素**：如果新列表中出现了旧列表没有的 `key`，React 会创建新的 DOM 节点；如果旧列表中的 `key` 在新列表中不存在，React 会删除对应的 DOM 节点。
4. **处理元素移动**：如果元素的 `key` 不变但位置发生变化，React 会通过移动 DOM 节点来更新列表，而不是销毁和重建。

# 4. 列表渲染的注意事项
1. **key 只在列表内部有效**：`key` 是给 React 内部使用的，不会传递给组件，不能在子组件中通过 `props.key` 获取。
2. **避免在 map 函数中定义组件**：在 `map` 函数中定义组件会导致每次渲染都创建新的组件，影响性能，应该将组件提取到外部。
    ```jsx
    // 推荐写法
    const FruitItem = ({ fruit }) => <li>{fruit.name}</li>;

    function FruitList() {
      const [fruits] = useState([{ id: 1, name: ''苹果'' }]);
      return (
        <ul>
          {fruits.map((fruit) => (
            <FruitItem key={fruit.id} fruit={fruit} />
          ))}
        </ul>
      );
    }
    ```
3. **列表项的状态管理**：当列表项是受控组件时，确保每个列表项的状态独立，避免因 `key` 问题导致状态共享。

# 5. 条件渲染与列表渲染的结合使用
在实际开发中，我们经常需要结合条件渲染和列表渲染，例如：当列表为空时显示“暂无数据”，有数据时显示列表。
```jsx
function TodoList() {
  const [todos, setTodos] = useState([]);

  return (
    <div>
      {todos.length === 0 ? (
        <p>暂无待办事项</p>
      ) : (
        <ul>
          {todos.map((todo) => (
            <li key={todo.id}>{todo.text}</li>
          ))}
        </ul>
      )}
    </div>
  );
}
```
', '763e50ae-d5ad-4770-b985-cb78491214e1', 'true', '2025-12-19 09:23:48.442953+00', '2025-12-19 09:23:48.442953+00'), ('482a9847-e6a4-4d3a-a1db-9ae9474249a4', '函数组件与类组件', '在 React 中，组件是构建 UI 的基本单元，根据定义方式的不同，主要分为**函数组件**和**类组件**两大类。二者在语法、特性、设计理念上存在显著差异，适用于不同的开发场景。

# 1. 核心特性
## 1.1 函数组件
函数组件是基于 JavaScript 普通函数的 React 组件，是 React 16.8 推出 **Hooks** 之后的推荐写法。
- **语法结构**：以函数形式定义，接收 `props` 作为参数，直接返回 JSX 结构。
  ```jsx
  function Greeting(props) {
    return <h1>Hello, {props.name}</h1>;
  }

  // 箭头函数写法（更简洁）
  const Greeting = (props) => <h1>Hello, {props.name}</h1>;
  ```
- **状态管理**：React 16.8 之前无内置状态管理能力，只能作为**无状态组件**使用；Hooks 推出后，可通过 `useState`、`useReducer` 实现状态管理。
- **生命周期**：没有类组件的生命周期钩子，通过 `useEffect` 等 Hooks 处理副作用（如数据请求、DOM 操作、订阅监听）。
- **this 指向**：不存在 `this` 关键字，无需考虑 `this` 绑定问题。

## 1.2 类组件
类组件是基于 ES6 Class 定义的 React 组件，是 Hooks 出现之前的主流写法。
- **语法结构**：继承 `React.Component` 或 `React.PureComponent`，必须实现 `render()` 方法返回 JSX 结构。
  ```jsx
  class Greeting extends React.Component {
    render() {
      return <h1>Hello, {this.props.name}</h1>;
    }
  }
  ```
- **状态管理**：通过 `this.state` 定义组件内部状态，通过 `this.setState()` 方法更新状态（支持异步更新、批量更新）。
- **生命周期**：拥有完整的生命周期钩子函数，如 `componentDidMount`、`componentDidUpdate`、`componentWillUnmount` 等，可在不同阶段执行逻辑。
- **this 指向**：需要注意 `this` 绑定问题，事件处理函数通常需要通过 `bind` 或箭头函数绑定 `this`。

# 2. 优缺点对比
| 维度         | 函数组件                                  | 类组件                                      |
|--------------|-------------------------------------------|---------------------------------------------|
| **语法简洁性** | 代码量少，结构清晰，学习成本低            | 语法繁琐，需要继承、实现 render 方法，代码冗余 |
| **状态管理** | 借助 Hooks 实现，逻辑分散且灵活            | 基于 state/setState，逻辑集中但写法固定      |
| **生命周期** | 用 useEffect 统一处理副作用，逻辑更聚合    | 钩子函数多，易出现生命周期嵌套地狱            |
| **性能优化** | 需手动使用 React.memo 优化，避免重复渲染   | 可继承 PureComponent 或实现 shouldComponentUpdate 进行浅比较优化 |
| **this 问题** | 无 this，彻底规避 this 绑定陷阱            | 存在 this 指向问题，需额外处理              |
| **逻辑复用** | 基于自定义 Hooks，复用逻辑更简洁、无嵌套   | 基于高阶组件（HOC）/Render Props，易产生嵌套地狱 |

# 3. 使用场景
## 3.1 函数组件（推荐优先使用）
1. **简单 UI 组件**：如按钮、标签、卡片等无状态或状态简单的组件，代码简洁易维护。
2. **复杂逻辑组件**：通过 Hooks 拆分和复用复杂业务逻辑（如数据请求、表单处理、状态管理），让组件逻辑更清晰。
3. **React 新版本项目**：React 官方推荐写法，后续生态（如 React Server Components）会更倾向于函数组件。

## 3.2 类组件（逐步淘汰，兼容老项目）
1. **老项目维护**：早期 React 项目大量使用类组件，维护时需要兼容原有代码。
2. **复杂生命周期场景**：在 Hooks 出现之前，类组件的生命周期钩子能更精细地控制组件不同阶段的行为（现在可通过 useEffect 替代）。
3. **团队技术栈兼容**：部分团队尚未完全迁移到 Hooks，仍需使用类组件开发。', '16d6f496-f7f3-422b-baf9-c5f027a71aaa', 'true', '2025-12-19 09:39:37.572904+00', '2025-12-19 09:39:37.572904+00'), ('4d4cc26c-6ce0-4786-bc94-13fa3d342045', 'useReducer：复杂状态逻辑', '`useReducer` 是 React 中用于管理**复杂状态逻辑**的 Hook，是 `useState` 的替代方案。当组件状态包含多个子值、状态更新逻辑复杂（如依赖多个前置状态）或需要集中管理状态变化时，`useReducer` 比 `useState` 更优雅、更易维护。其设计灵感来源于 Redux，核心思想是“状态与操作分离”，通过纯函数（reducer）处理状态更新逻辑。

# 1. useReducer 核心概念与工作原理
## 1.1 核心概念
- **state**：组件的状态对象（与 `useState` 的 state 一致）。
- **action**：描述状态变化的“指令”，通常是包含 `type` 字段的对象（如 `{ type: ''INCREMENT'' }`），可携带额外数据（`payload`）。
- **reducer**：纯函数，接收当前 `state` 和 `action`，返回新的 `state`（核心逻辑：根据 action 类型更新 state）。
- **dispatch**：分发 action 的函数，调用 `dispatch(action)` 会触发 reducer 执行，更新 state 并重新渲染组件。

## 1.2 工作流程
1. 组件初始化时，`useReducer` 执行 reducer 并传入初始 state（或通过 `init` 函数生成初始 state）。
2. 组件中调用 `dispatch(action)`，传递状态更新指令。
3. React 调用 reducer 函数，传入当前 state 和 action，计算新的 state。
4. React 用新的 state 重新渲染组件，并更新 UI。

## 1.3 基本语法
```jsx
import { useReducer } from ''react'';

// 1. 定义 reducer 纯函数
function reducer(state, action) {
  switch (action.type) {
    case ''INCREMENT'':
      return { ...state, count: state.count + 1 };
    case ''DECREMENT'':
      return { ...state, count: state.count - 1 };
    case ''RESET'':
      return { ...state, count: action.payload };
    default:
      throw new Error(`未知 action 类型：${action.type}`);
  }
}

function Counter() {
  // 2. 初始化 useReducer：reducer 函数 + 初始 state
  const [state, dispatch] = useReducer(reducer, { count: 0 });

  return (
    <div>
      <p>计数：{state.count}</p>
      {/* 3. 分发 action，触发状态更新 */}
      <button onClick={() => dispatch({ type: ''INCREMENT'' })}>+1</button>
      <button onClick={() => dispatch({ type: ''DECREMENT'' })}>-1</button>
      <button onClick={() => dispatch({ type: ''RESET'', payload: 0 })}>重置</button>
    </div>
  );
}
```

# 2. useReducer 与 useState 的对比
## 2.1 适用场景对比
| 场景                     | 推荐使用        | 原因                                   |
|--------------------------|-----------------|----------------------------------------|
| 简单状态（单个值）| useState        | 语法简洁，无需额外定义 reducer          |
| 复杂状态（多个子值）| useReducer      | 集中管理状态更新逻辑，代码更清晰        |
| 状态更新依赖前置状态     | useReducer      | reducer 接收当前 state，避免批量更新问题 |
| 组件内状态逻辑复用       | useReducer      | reducer 可抽离为独立函数，便于复用      |
| 状态更新需要追踪（调试）| useReducer      | action 类型明确，便于定位状态变化原因   |

## 2.2 代码复杂度对比
### 示例：用 useState 管理复杂状态（待办事项）
```jsx
// 状态分散，更新逻辑零散，维护成本高
function TodoList() {
  const [todos, setTodos] = useState([]);
  const [inputValue, setInputValue] = useState('''');

  const addTodo = () => {
    setTodos(prev => [...prev, { id: Date.now(), text: inputValue, done: false }]);
    setInputValue('''');
  };

  const toggleTodo = (id) => {
    setTodos(prev => prev.map(todo => 
      todo.id === id ? { ...todo, done: !todo.done } : todo
    ));
  };

  const deleteTodo = (id) => {
    setTodos(prev => prev.filter(todo => todo.id !== id));
  };

  // ... 更多更新逻辑
}
```

### 示例：用 useReducer 管理复杂状态（待办事项）
```jsx
// 1. 抽离 reducer，集中管理所有状态更新逻辑
function todoReducer(state, action) {
  switch (action.type) {
    case ''ADD_TODO'':
      return [...state, { id: Date.now(), text: action.payload, done: false }];
    case ''TOGGLE_TODO'':
      return state.map(todo => 
        todo.id === action.payload ? { ...todo, done: !todo.done } : todo
      );
    case ''DELETE_TODO'':
      return state.filter(todo => todo.id !== action.payload);
    default:
      return state;
  }
}

function TodoList() {
  const [todos, dispatch] = useReducer(todoReducer, []);
  const [inputValue, setInputValue] = useState('''');

  const addTodo = () => {
    dispatch({ type: ''ADD_TODO'', payload: inputValue });
    setInputValue('''');
  };

  return (
    <div>
      <input value={inputValue} onChange={(e) => setInputValue(e.target.value)} />
      <button onClick={addTodo}>添加</button>
      <ul>
        {todos.map(todo => (
          <li key={todo.id}>
            <span style={{ textDecoration: todo.done ? ''line-through'' : ''none'' }}>
              {todo.text}
            </span>
            <button onClick={() => dispatch({ type: ''TOGGLE_TODO'', payload: todo.id })}>
              切换
            </button>
            <button onClick={() => dispatch({ type: ''DELETE_TODO'', payload: todo.id })}>
              删除
            </button>
          </li>
        ))}
      </ul>
    </div>
  );
}
```

# 3. 高级用法：初始化 state 与懒加载
## 3.1 直接初始化 state
最基础的方式：将初始 state 作为 `useReducer` 的第二个参数：
```jsx
const [state, dispatch] = useReducer(reducer, { count: 0 });
```

## 3.2 懒加载初始化 state
若初始 state 需要复杂计算（如从本地存储读取、根据 props 生成），可传递一个**初始化函数**作为第三个参数，`useReducer` 会在组件首次渲染时执行该函数生成初始 state：
```jsx
// 初始化函数：根据 props 生成初始 state
function init(initialCount) {
  return { count: initialCount, history: [initialCount] };
}

function Counter({ initialCount }) {
  // 第三个参数为初始化函数，第二个参数为初始化函数的入参
  const [state, dispatch] = useReducer(reducer, initialCount, init);

  // ...
}
```

## 3.3 重置 state 到初始值
结合初始化函数，可实现“重置 state 到初始值”的功能：
```jsx
function reducer(state, action) {
  switch (action.type) {
    case ''RESET'':
      // 调用 init 函数，重置为初始 state
      return init(action.payload);
    // ... 其他 action
  }
}

// 组件中调用
dispatch({ type: ''RESET'', payload: initialCount });
```

# 4. useReducer 与 Redux 的关系
## 4.1 相似点
- 核心思想一致：通过 reducer 纯函数处理状态更新，action 描述状态变化，dispatch 分发 action。
- 状态不可变：reducer 必须返回新的 state，不能直接修改原 state。
- 纯函数约束：reducer 不能包含副作用（如数据请求、DOM 操作）。

## 4.2 区别
| 特性         | useReducer                      | Redux                              |
|--------------|---------------------------------|------------------------------------|
| 作用域       | 组件内局部状态管理              | 全局状态管理（跨组件共享）|
| 中间件支持   | 不支持                          | 支持（如 redux-thunk、redux-saga） |
| 调试工具     | 无专用工具                      | 支持 Redux DevTools 调试           |
| 额外依赖     | 无需额外安装（React 内置）| 需要安装 redux、react-redux 等     |
| 适用场景     | 组件内复杂状态                  | 全局共享状态、大型应用             |

## 4.3 useReducer 作为 Redux 极简版
对于小型应用或组件内复杂状态，`useReducer` + `useContext` 可替代 Redux 实现全局状态管理：
```jsx
// 1. 创建 Context
const StoreContext = createContext();

// 2. 创建 Provider 组件，封装 useReducer
function StoreProvider({ children }) {
  const [state, dispatch] = useReducer(rootReducer, initialState);
  return (
    <StoreContext.Provider value={{ state, dispatch }}>
      {children}
    </StoreContext.Provider>
  );
}

// 3. 全局使用
function App() {
  return (
    <StoreProvider>
      <ComponentA />
      <ComponentB />
    </StoreProvider>
  );
}

// 4. 子组件消费
function ComponentA() {
  const { state, dispatch } = useContext(StoreContext);
  return (
    <button onClick={() => dispatch({ type: ''INCREMENT'' })}>
      {state.count}
    </button>
  );
}
```

# 5. useReducer 最佳实践
## 5.1 抽离 reducer 为独立文件
复杂应用中，将 reducer 抽离为独立文件，便于维护和复用：
```jsx
// src/reducers/todoReducer.js
export default function todoReducer(state, action) {
  switch (action.type) {
    case ''ADD_TODO'':
      return [...state, { id: Date.now(), text: action.payload, done: false }];
    // ... 其他 action
    default:
      return state;
  }
}

// 组件中导入
import todoReducer from ''../reducers/todoReducer'';
```

## 5.2 使用 action creator 统一创建 action
避免在组件中直接编写 action 对象，抽离为 action creator 函数，减少重复代码：
```jsx
// src/actions/todoActions.js
export const addTodo = (text) => ({
  type: ''ADD_TODO'',
  payload: text
});

export const toggleTodo = (id) => ({
  type: ''TOGGLE_TODO'',
  payload: id
});

// 组件中使用
import { addTodo, toggleTodo } from ''../actions/todoActions'';

// 分发 action
dispatch(addTodo(inputValue));
dispatch(toggleTodo(todo.id));
```

## 5.3 合理拆分 reducer
当全局状态复杂时，拆分多个子 reducer，通过 `combineReducers` 合并（类似 Redux）：
```jsx
// 子 reducer
function todoReducer(state, action) { /* ... */ }
function userReducer(state, action) { /* ... */ }

// 合并 reducer
function rootReducer(state, action) {
  return {
    todos: todoReducer(state.todos, action),
    user: userReducer(state.user, action)
  };
}
```

# 6. 核心总结
1. **核心作用**：管理复杂状态逻辑，替代 `useState` 处理多子值、多更新逻辑的状态。
2. **核心流程**：`dispatch(action)` → `reducer(state, action)` → 返回新 state → 组件渲染。
3. **适用场景**：
   - 组件状态包含多个子值（如对象、数组）。
   - 状态更新逻辑复杂（依赖前置状态、多条件更新）。
   - 需要集中管理状态变化（便于调试和维护）。
4. **高级特性**：
   - 懒加载初始化 state（通过初始化函数）。
   - 结合 `useContext` 实现全局状态管理（替代 Redux 极简版）。
5. **最佳实践**：
   - 抽离 reducer 和 action creator 为独立文件。
   - 复杂状态拆分 reducer，保持单一职责。
   - 遵循不可变原则，reducer 中返回新 state。...', 'aac29662-babe-4c96-8f61-0a16830155d4', 'true', '2025-12-19 15:12:13.205458+00', '2025-12-22 02:21:33.508503+00'), ('4f7ca80c-d51b-4207-bb8c-b3ccf7d6dc26', '常用自定义 Hooks 实现', '以下是三个高频实用的自定义 Hooks 实现，包含完整代码、核心逻辑解析和使用示例：

# 1. useRequest：通用网络请求 Hooks
## 1.1 功能说明
封装网络请求的核心逻辑（加载状态、数据、错误、重试），支持手动触发、自动请求、取消请求，适配 Promise 风格的请求函数（如 fetch、axios）。

## 1.2 完整实现
```jsx
import { useState, useCallback, useRef, useEffect } from ''react'';

function useRequest(requestFn, options = {}) {
  const { autoRun = true, onSuccess, onError } = options;
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const abortControllerRef = useRef(null); // 用于取消请求

  // 核心请求逻辑
  const run = useCallback(async (...args) => {
    // 取消上一次未完成的请求
    if (abortControllerRef.current) {
      abortControllerRef.current.abort();
    }
    abortControllerRef.current = new AbortController();
    
    setLoading(true);
    setError(null);
    try {
      // 传入取消信号，支持请求取消
      const result = await requestFn(...args, abortControllerRef.current.signal);
      setData(result);
      onSuccess?.(result); // 成功回调
      return result;
    } catch (err) {
      if (err.name !== ''AbortError'') { // 排除手动取消的错误
        setError(err);
        onError?.(err); // 失败回调
      }
      return null;
    } finally {
      setLoading(false);
    }
  }, [requestFn, onSuccess, onError]);

  // 取消请求
  const cancel = useCallback(() => {
    if (abortControllerRef.current) {
      abortControllerRef.current.abort();
      abortControllerRef.current = null;
    }
  }, []);

  // 自动执行请求
  useEffect(() => {
    if (autoRun) {
      run();
    }
    // 组件卸载时取消请求
    return () => cancel();
  }, [autoRun, run, cancel]);

  return { data, loading, error, run, cancel };
}
```

## 1.3 使用示例
```jsx
// 定义请求函数
const fetchUser = async (id, signal) => {
  const res = await fetch(`https://api.example.com/user/${id}`, { signal });
  return res.json();
};

function UserComponent() {
  const { data: user, loading, error, run } = useRequest(fetchUser, {
    autoRun: false, // 关闭自动请求
    onSuccess: (data) => console.log(''请求成功：'', data),
    onError: (err) => console.error(''请求失败：'', err),
  });

  return (
    <div>
      <button onClick={() => run(123)} disabled={loading}>
        加载用户信息
      </button>
      {loading && <p>加载中...</p>}
      {error && <p>错误：{error.message}</p>}
      {user && <p>用户名：{user.name}</p>}
    </div>
  );
}
```

# 2. useLocalStorage：本地存储 Hooks
## 2.1 功能说明
封装 localStorage 的读写逻辑，实现“状态与本地存储同步”，支持初始值、数据序列化/反序列化，处理异常场景（如无存储权限）。

## 2.2 完整实现
```jsx
import { useState, useCallback } from ''react'';

function useLocalStorage(key, initialValue) {
  // 初始化：优先从本地存储读取，失败则用初始值
  const [storedValue, setStoredValue] = useState(() => {
    try {
      const item = window.localStorage.getItem(key);
      // 反序列化：本地存储为字符串，转换为原始类型
      return item ? JSON.parse(item) : initialValue;
    } catch (error) {
      console.error(''读取localStorage失败：'', error);
      return initialValue;
    }
  });

  // 写入本地存储并更新状态
  const setValue = useCallback((value) => {
    try {
      // 支持函数式更新（与useState保持一致）
      const valueToStore = value instanceof Function ? value(storedValue) : value;
      setStoredValue(valueToStore);
      // 序列化：将数据转为字符串存储
      window.localStorage.setItem(key, JSON.stringify(valueToStore));
    } catch (error) {
      console.error(''写入localStorage失败：'', error);
    }
  }, [key, storedValue]);

  // 移除本地存储项
  const removeValue = useCallback(() => {
    try {
      window.localStorage.removeItem(key);
      setStoredValue(initialValue);
    } catch (error) {
      console.error(''移除localStorage项失败：'', error);
    }
  }, [key, initialValue]);

  return [storedValue, setValue, removeValue];
}
```

## 2.3 使用示例
```jsx
function ThemeSwitch() {
  // 初始化：从localStorage读取theme，无则默认light
  const [theme, setTheme, removeTheme] = useLocalStorage(''app-theme'', ''light'');

  const toggleTheme = () => {
    setTheme(prev => prev === ''light'' ? ''dark'' : ''light'');
  };

  return (
    <div className={`theme-${theme}`}>
      <p>当前主题：{theme}</p>
      <button onClick={toggleTheme}>切换主题</button>
      <button onClick={removeTheme}>重置主题</button>
    </div>
  );
}
```

# 3. useDebounce：防抖 Hooks
## 3.1 功能说明
实现值的防抖处理，延迟更新值（如搜索框输入、窗口尺寸变化），避免高频触发逻辑（如请求、渲染），支持自定义延迟时间、立即执行。

## 3.2 完整实现
```jsx
import { useState, useEffect, useCallback } from ''react'';

function useDebounce(value, delay = 500, options = { leading: false }) {
  const { leading } = options;
  const [debouncedValue, setDebouncedValue] = useState(value);
  const timerRef = useRef(null);

  // 防抖核心逻辑
  useEffect(() => {
    // 立即执行：首次触发时同步更新值（leading = true）
    if (leading && timerRef.current === null) {
      setDebouncedValue(value);
    } else {
      // 清除上一次定时器
      if (timerRef.current) {
        clearTimeout(timerRef.current);
      }
      // 延迟更新值
      timerRef.current = setTimeout(() => {
        setDebouncedValue(value);
        timerRef.current = null;
      }, delay);
    }

    // 组件卸载/依赖变化时清除定时器
    return () => {
      if (timerRef.current) {
        clearTimeout(timerRef.current);
      }
    };
  }, [value, delay, leading]);

  // 手动触发更新防抖值
  const flush = useCallback(() => {
    if (timerRef.current) {
      clearTimeout(timerRef.current);
      timerRef.current = null;
      setDebouncedValue(value);
    }
  }, [value]);

  return [debouncedValue, flush];
}
```

## 3.3 使用示例
```jsx
function SearchBox() {
  const [inputValue, setInputValue] = useState('''');
  // 防抖处理：输入停止500ms后更新debouncedValue
  const [debouncedValue, flushDebounce] = useDebounce(inputValue, 500);

  // 防抖值变化时触发搜索
  useEffect(() => {
    if (debouncedValue) {
      console.log(''搜索：'', debouncedValue);
      // 执行搜索请求逻辑
    }
  }, [debouncedValue]);

  return (
    <div>
      <input
        type="text"
        value={inputValue}
        onChange={(e) => setInputValue(e.target.value)}
        placeholder="输入搜索内容..."
      />
      <button onClick={flushDebounce}>立即搜索</button>
      <p>防抖后的值：{debouncedValue}</p>
    </div>
  );
}
```', '9e07a04e-b6bb-488a-9725-08821605cfbc', 'true', '2025-12-22 02:22:34.493316+00', '2025-12-22 02:50:00.172823+00'), ('53467990-3a1c-48c8-ae2b-5d3bb36bbecb', '表单验证', '表单验证是确保用户输入数据合法的关键步骤，常见验证场景包括：必填项校验、格式校验（如手机号、邮箱）、长度校验、数值范围校验等。React 中表单验证可分为**手动验证**（自定义逻辑）和**正则表达式校验**（高效匹配格式），可结合受控/非受控表单实现。

# 1. 验证时机
根据用户体验需求，可选择不同的验证时机：
- 即时验证：用户输入过程中（`onChange`）实时校验，即时反馈错误；
- 失焦验证：用户离开表单字段时（`onBlur`）校验，避免频繁干扰；
- 提交验证：表单提交时（`onSubmit`）校验，阻止非法数据提交；
- 组合验证：如“失焦验证 + 提交验证”，兼顾体验和准确性。

# 2. 手动验证（自定义逻辑）
手动验证通过编写条件判断逻辑，检查表单字段是否符合要求，适用于简单的校验规则（如必填、长度限制、数值范围）。

## 2.1 受控表单 + 提交验证（基础示例）
```javascript
import { useState } from ''react'';

function ManualValidationForm() {
  const [formData, setFormData] = useState({
    username: '''',
    password: '''',
    age: ''''
  });

  // 存储错误信息（key 对应字段名，value 为错误提示）
  const [errors, setErrors] = useState({});

  // 更新表单数据
  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
    // 输入时清除对应字段的错误提示（可选）
    if (errors[name]) {
      setErrors(prev => ({ ...prev, [name]: '''' }));
    }
  };

  // 表单验证逻辑（返回是否通过验证，同时更新错误信息）
  const validateForm = () => {
    const newErrors = {};

    // 用户名校验：必填 + 长度 3-10 位
    if (!formData.username.trim()) {
      newErrors.username = ''用户名不能为空'';
    } else if (formData.username.length < 3 || formData.username.length > 10) {
      newErrors.username = ''用户名长度需在 3-10 位之间'';
    }

    // 密码校验：必填 + 长度 >=6 位
    if (!formData.password.trim()) {
      newErrors.password = ''密码不能为空'';
    } else if (formData.password.length < 6) {
      newErrors.password = ''密码长度不能少于 6 位'';
    }

    // 年龄校验：必填 + 数字 + 18-60 岁
    if (!formData.age.trim()) {
      newErrors.age = ''年龄不能为空'';
    } else {
      const age = Number(formData.age);
      if (isNaN(age)) {
        newErrors.age = ''年龄必须是数字'';
      } else if (age < 18 || age > 60) {
        newErrors.age = ''年龄需在 18-60 岁之间'';
      }
    }

    // 更新错误信息
    setErrors(newErrors);
    // 无错误则返回 true（验证通过）
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    // 提交前执行验证
    const isVaild = validateForm();
    if (isVaild) {
      console.log(''表单验证通过，提交数据：'', formData);
      // 后续：接口请求等逻辑
    }
  };

  return (
    <form onSubmit={handleSubmit} style={{ display: ''flex'', flexDirection: ''column'', gap: ''10px'' }}>
      <div>
        <label>用户名：</label>
        <input
          type="text"
          name="username"
          value={formData.username}
          onChange={handleChange}
          placeholder="请输入用户名"
        />
        {/* 显示错误提示 */}
        {errors.username && <span style={{ color: ''red'', fontSize: ''12px'' }}>{errors.username}</span>}
      </div>

      <div>
        <label>密码：</label>
        <input
          type="password"
          name="password"
          value={formData.password}
          onChange={handleChange}
          placeholder="请输入密码"
        />
        {errors.password && <span style={{ color: ''red'', fontSize: ''12px'' }}>{errors.password}</span>}
      </div>

      <div>
        <label>年龄：</label>
        <input
          type="text"
          name="age"
          value={formData.age}
          onChange={handleChange}
          placeholder="请输入年龄"
        />
        {errors.age && <span style={{ color: ''red'', fontSize: ''12px'' }}>{errors.age}</span>}
      </div>

      <button type="submit">提交</button>
    </form>
  );
}
```

## 2.2 受控表单 + 即时验证（onChange）
即时验证在用户输入时实时反馈错误，提升用户体验，但需注意避免频繁重渲染。

```javascript
import { useState } from ''react'';

function InstantValidationForm() {
  const [formData, setFormData] = useState({
    email: '''',
    phone: ''''
  });
  const [errors, setErrors] = useState({});

  // 单个字段的验证逻辑
  const validateField = (name, value) => {
    let error = '''';
    switch (name) {
      case ''email'':
        if (!value.trim()) {
          error = ''邮箱不能为空'';
        } else if (!/^[\w.-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$/.test(value)) {
          error = ''邮箱格式不正确（如：xxx@xxx.com）'';
        }
        break;
      case ''phone'':
        if (!value.trim()) {
          error = ''手机号不能为空'';
        } else if (!/^1[3-9]\d{9}$/.test(value)) {
          error = ''手机号格式不正确（11位数字）'';
        }
        break;
      default:
        break;
    }
    return error;
  };

  // 输入时实时验证
  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
    // 验证当前字段并更新错误信息
    const error = validateField(name, value);
    setErrors(prev => ({ ...prev, [name]: error }));
  };

  // 提交时最终验证（防止用户绕过输入验证）
  const handleSubmit = (e) => {
    e.preventDefault();
    const newErrors = {
      email: validateField(''email'', formData.email),
      phone: validateField(''phone'', formData.phone)
    };
    setErrors(newErrors);
    if (Object.keys(newErrors).every(key => !newErrors[key])) {
      console.log(''验证通过，提交数据：'', formData);
    }
  };

  return (
    <form onSubmit={handleSubmit} style={{ display: ''flex'', flexDirection: ''column'', gap: ''10px'' }}>
      <div>
        <label>邮箱：</label>
        <input
          type="email"
          name="email"
          value={formData.email}
          onChange={handleChange}
          placeholder="请输入邮箱"
        />
        {errors.email && <span style={{ color: ''red'', fontSize: ''12px'' }}>{errors.email}</span>}
      </div>

      <div>
        <label>手机号：</label>
        <input
          type="text"
          name="phone"
          value={formData.phone}
          onChange={handleChange}
          placeholder="请输入手机号"
        />
        {errors.phone && <span style={{ color: ''red'', fontSize: ''12px'' }}>{errors.phone}</span>}
      </div>

      <button type="submit">提交</button>
    </form>
  );
}
```

## 2.3 非受控表单 + 提交验证
非受控表单通过 `ref` 获取字段值后，执行验证逻辑。

```javascript
import { useRef, useState } from ''react'';

function UncontrolledValidationForm() {
  const formRef = useRef(null);
  const [errors, setErrors] = useState({});

  const validateForm = () => {
    const form = formRef.current;
    const newErrors = {};

    // 用户名校验
    const username = form.username.value.trim();
    if (!username) {
      newErrors.username = ''用户名不能为空'';
    } else if (username.length < 3) {
      newErrors.username = ''用户名长度不能少于 3 位'';
    }

    // 密码校验
    const password = form.password.value.trim();
    if (!password) {
      newErrors.password = ''密码不能为空'';
    } else if (password.length < 6) {
      newErrors.password = ''密码长度不能少于 6 位'';
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    const isVaild = validateForm();
    if (isVaild) {
      const form = formRef.current;
      console.log(''提交数据：'', {
        username: form.username.value,
        password: form.password.value
      });
      form.reset();
    }
  };

  return (
    <form ref={formRef} onSubmit={handleSubmit} style={{ display: ''flex'', flexDirection: ''column'', gap: ''10px'' }}>
      <div>
        <label>用户名：</label>
        <input type="text" name="username" placeholder="请输入用户名" />
        {errors.username && <span style={{ color: ''red'', fontSize: ''12px'' }}>{errors.username}</span>}
      </div>
      <div>
        <label>密码：</label>
        <input type="password" name="password" placeholder="请输入密码" />
        {errors.password && <span style={{ color: ''red'', fontSize: ''12px'' }}>{errors.password}</span>}
      </div>
      <button type="submit">提交</button>
    </form>
  );
}
```

# 3. 正则表达式校验（常用格式匹配）
正则表达式是高效的字符串格式匹配工具，适用于邮箱、手机号、身份证号、密码强度等复杂格式校验。以下是常见场景的正则表达式及使用示例。

## 3.1 常用正则表达式汇总
| 校验场景       | 正则表达式                                  | 说明                                  |
|----------------|---------------------------------------------|---------------------------------------|
| 邮箱           | `^[\w.-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$`     | 支持字母、数字、下划线、点、短横线    |
| 手机号         | `^1[3-9]\d{9}$`                             | 中国大陆手机号（11位，以13-19开头）   |
| 身份证号（18位）| `^[1-9]\d{5}(18|19|20)\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$` | 支持最后一位为X/x                      |
| 用户名         | `^[a-zA-Z0-9_]{3,16}$`                      | 字母、数字、下划线，3-16位             |
| 密码（强）     | `^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$` | 包含大小写字母、数字、特殊字符，8位以上 |
| 中文姓名       | `^[\u4e00-\u9fa5]{2,6}$`                    | 2-6位中文汉字                          |
| 邮政编码       | `^[1-9]\d{5}$`                              | 中国大陆邮政编码（6位数字）            |
| URL            | `^https?:\/\/([\w.-]+)\.([a-zA-Z]{2,})(\/.*)?$` | 支持 http/https 协议                  |

## 3.2 正则表达式校验示例（密码强度 + 邮箱 + 手机号）
```javascript
import { useState } from ''react'';

function RegexValidationForm() {
  const [formData, setFormData] = useState({
    email: '''',
    phone: '''',
    password: ''''
  });
  const [errors, setErrors] = useState({});
  // 密码强度提示（可选）
  const [passwordStrength, setPasswordStrength] = useState('''');

  // 正则表达式定义
  const regexRules = {
    email: /^[\w.-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$/,
    phone: /^1[3-9]\d{9}$/,
    password: /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$/
  };

  // 密码强度检测（可选增强功能）
  const checkPasswordStrength = (password) => {
    if (password.length < 6) return ''弱'';
    if (password.length < 8 && /^[a-zA-Z0-9]+$/.test(password)) return ''中'';
    if (regexRules.password.test(password)) return ''强'';
    return ''中'';
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));

    // 字段验证
    let error = '''';
    if (!value.trim()) {
      error = `${name === ''email'' ? ''邮箱'' : name === ''phone'' ? ''手机号'' : ''密码''}不能为空`;
    } else if (!regexRules[name].test(value)) {
      error = {
        email: ''邮箱格式不正确（如：xxx@xxx.com）'',
        phone: ''手机号格式不正确（11位数字）'',
        password: ''密码需包含大小写字母、数字、特殊字符，且长度≥8位''
      }[name];
    }
    setErrors(prev => ({ ...prev, [name]: error }));

    // 密码强度检测
    if (name === ''password'') {
      setPasswordStrength(checkPasswordStrength(value));
    }
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    const newErrors = {};

    // 提交时最终验证
    Object.keys(regexRules).forEach(key => {
      const value = formData[key].trim();
      if (!value) {
        newErrors[key] = `${key === ''email'' ? ''邮箱'' : key === ''phone'' ? ''手机号'' : ''密码''}不能为空`;
      } else if (!regexRules[key].test(value)) {
        newErrors[key] = {
          email: ''邮箱格式不正确'',
     ...', '0e360aa6-df1e-4212-b06e-7ebc4541f5d5', 'true', '2025-12-22 03:18:47.534454+00', '2025-12-23 13:02:59.948529+00'), ('544a877d-ac3d-4150-88d5-30852804b215', '轻量状态管理方案', '除了 Zustand，React 生态中还有两款聚焦“原子化状态管理”的轻量方案——Recoil（Facebook 出品）和 Jotai（基于 Recoil 理念优化），核心特点是**将状态拆分为细粒度的原子（Atom），组件按需订阅原子，实现精准更新**，弥补了 Context 全局重渲染的缺陷，同时保持极简的 API 设计。

# 1. Recoil（原子化状态管理先驱）
## 1.1 核心概念
- **Atom（原子）**：最小粒度的状态单元，可被组件订阅，更新时仅触发订阅该原子的组件重渲染；
- **Selector（选择器）**：派生状态，基于 Atom 或其他 Selector 计算得到（支持同步/异步）；
- **RecoilRoot**：全局 Provider，需包裹应用根组件，提供原子状态上下文。

## 1.2 核心特性
- 原子化状态：状态拆分为独立原子，组件按需订阅，避免全局重渲染；
- 派生状态：Selector 支持同步/异步计算（如基于用户 ID 异步获取用户信息）；
- 兼容 React 并发模式：设计时考虑了 React 新特性，支持 Suspense 处理异步状态；
- 轻量简洁：API 简单，学习成本低于 Redux，高于 Context；
- TypeScript 友好：天然支持类型推断。

## 1.3 快速上手
### 1.3.1 安装
```bash
npm install recoil

yarn add recoil
```

### 1.3.2 基本使用（计数器示例）
```javascript
import { RecoilRoot, atom, useRecoilState, selector, useRecoilValue } from ''recoil'';

// 1. 定义原子状态
const countAtom = atom({
  key: ''count'', // 全局唯一标识（必须）
  default: 0 // 初始值
});

// 2. 定义派生状态（Selector）
const doubleCountSelector = selector({
  key: ''doubleCount'',
  get: ({ get }) => {
    // 基于 countAtom 计算派生值
    const count = get(countAtom);
    return count * 2;
  }
});

// 3. 消费原子的组件
function Counter() {
  // 订阅并修改 countAtom
  const [count, setCount] = useRecoilState(countAtom);
  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>加 1</button>
    </div>
  );
}

// 4. 消费派生状态的组件
function DoubleCounter() {
  // 仅订阅派生状态，不修改
  const doubleCount = useRecoilValue(doubleCountSelector);
  return <p>Double Count: {doubleCount}</p>;
}

// 5. 根组件包裹 RecoilRoot
function App() {
  return (
    <RecoilRoot>
      <Counter />
      <DoubleCounter />
    </RecoilRoot>
  );
}
```

### 1.3.3 异步 Selector（获取用户信息）
```javascript
const userIdAtom = atom({
  key: ''userId'',
  default: 1
});

const userInfoSelector = selector({
  key: ''userInfo'',
  get: async ({ get }) => {
    const userId = get(userIdAtom);
    const res = await fetch(`https://jsonplaceholder.typicode.com/users/${userId}`);
    return res.json();
  }
});

// 组件中使用（结合 Suspense 处理加载状态）
function UserInfo() {
  const userInfo = useRecoilValue(userInfoSelector);
  return (
    <div>
      <h3>{userInfo.name}</h3>
      <p>{userInfo.email}</p>
    </div>
  );
}

function App() {
  return (
    <RecoilRoot>
      <Suspense fallback={<div>加载中...</div>}>
        <UserInfo />
      </Suspense>
    </RecoilRoot>
  );
}
```

## 1.4 优缺点与适用场景
| 优点 | 缺点 |
|------|------|
| 原子化状态，精准更新（仅订阅组件重渲染） | 需包裹 RecoilRoot，增加组件层级 |
| 强大的派生状态能力（支持异步） | 生态不如 Zustand/Redux 丰富 |
| 兼容 React 并发模式/Suspense | 部分场景下（如原子依赖过多）Selector 计算复杂 |
| API 简洁，学习成本低 | 暂未正式发布 1.0 版本（存在少量不稳定 API） |

**适用场景**：
- 需细粒度状态共享的 React 项目；
- 依赖派生状态（如计算属性、异步数据）的场景；
- 追求 React 新特性（并发模式、Suspense）兼容的项目；
- 中小型应用，不想引入 Redux 但需要比 Context 更优的性能。

# 2. Jotai（Recoil 轻量化替代）
Jotai 由 React 核心团队成员开发，基于 Recoil 的原子化理念，简化了 API 设计，移除了 RecoilRoot 的强制要求（可选），体积更小（~2KB gzip），性能更优，成为近年来备受推崇的轻量状态管理方案。

## 2.1 核心概念
- **Atom**：与 Recoil 一致，最小粒度的状态单元，支持默认值、只读/可写；
- **Selector**：派生状态，支持同步/异步，API 比 Recoil 更简洁；
- **Provider（可选）**：默认无需 Provider，复杂场景（如多实例、持久化）可使用 Provider。

## 2.2 核心特性
- 无强制 Provider：默认全局共享原子，简化组件层级；
- 极简 API：原子创建、订阅、修改的语法比 Recoil 更简洁；
- 更小体积：~2KB gzip，比 Recoil 更轻量；
- 支持 Suspense/并发模式：与 Recoil 一致；
- 丰富的扩展：支持持久化、原子联动、批量更新等；
- TypeScript 友好：完全类型安全。

## 2.3 快速上手
### 2.3.1 安装
```bash
npm install jotai

yarn add jotai
```

### 2.3.2 基本使用（计数器示例）
```javascript
import { atom, useAtom, useAtomValue } from ''jotai'';

// 1. 定义原子状态
const countAtom = atom(0); // 直接传入初始值，无需 key（可选 key 用于调试）

// 2. 定义派生状态（Selector）
const doubleCountAtom = atom((get) => {
  const count = get(countAtom);
  return count * 2;
});

// 3. 消费原子的组件
function Counter() {
  const [count, setCount] = useAtom(countAtom);
  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>加 1</button>
      <button onClick={() => setCount((prev) => prev - 1)}>减 1</button>
    </div>
  );
}

// 4. 消费派生状态的组件
function DoubleCounter() {
  const doubleCount = useAtomValue(doubleCountAtom);
  return <p>Double Count: {doubleCount}</p>;
}

// 5. 根组件无需 Provider
function App() {
  return (
    <div>
      <Counter />
      <DoubleCounter />
    </div>
  );
}
```

### 2.3.3 异步 Atom（获取用户信息）
```javascript
import { atom, useAtomValue } from ''jotai'';
import { Suspense } from ''react'';

// 定义异步原子
const userIdAtom = atom(1);
const userInfoAtom = atom(async (get) => {
  const userId = get(userIdAtom);
  const res = await fetch(`https://jsonplaceholder.typicode.com/users/${userId}`);
  return res.json();
});

// 组件中使用
function UserInfo() {
  const userInfo = useAtomValue(userInfoAtom);
  return (
    <div>
      <h3>{userInfo.name}</h3>
      <p>{userInfo.email}</p>
    </div>
  );
}

function App() {
  return (
    <Suspense fallback={<div>加载中...</div>}>
      <UserInfo />
    </Suspense>
  );
}
```

### 2.3.4 持久化扩展（jotai-persist）
```javascript
import { atom, useAtom } from ''jotai'';
import { persistAtom } from ''jotai/utils'';

// 定义持久化原子
const themeAtom = atom(''light'');
// 添加持久化中间件
const persistedThemeAtom = atom(
  (get) => get(themeAtom),
  (get, set, update) => {
    set(themeAtom, update);
  }
);
persistedThemeAtom.onMount = (setAtom) => {
  const saved = localStorage.getItem(''theme'');
  if (saved) setAtom(saved);
};

function ThemeToggle() {
  const [theme, setTheme] = useAtom(persistedThemeAtom);
  const toggleTheme = () => setTheme(prev => prev === ''light'' ? ''dark'' : ''light'');
  return <button onClick={toggleTheme}>当前主题：{theme}</button>;
}
```

## 2.4 优缺点与适用场景
| 优点 | 缺点 |
|------|------|
| 无强制 Provider，组件层级更简洁 | 生态不如 Redux 丰富 |
| 体积极小，性能优异 | 仅支持 React 生态（无跨框架能力） |
| API 极简，学习成本低于 Recoil/Redux | 大型项目中原子管理需手动规范 |
| 支持 Suspense/并发模式 | 调试工具功能较基础 |
| 丰富的内置扩展（持久化、批量更新等） | 复杂异步流程处理能力弱于 Redux-Saga |

**适用场景**：
- 中小型 React 项目，追求极致简洁的状态管理；
- 需细粒度状态更新，避免 Context 全局重渲染；
- 依赖异步派生状态的场景（如 API 数据获取）；
- 对打包体积敏感的项目（如移动端、小程序）；
- 喜欢 Recoil 理念但想简化 API 的开发者。

# 3. Recoil vs Jotai 核心差异
| 维度                | Recoil                    | Jotai                     |
|---------------------|---------------------------|---------------------------|
| 强制 Provider       | 是（RecoilRoot）| 否（可选）|
| 体积                | ~4KB gzip                 | ~2KB gzip                 |
| API 简洁度          | 中等                      | 极高                      |
| 原子 key            | 必须                      | 可选                      |
| 扩展能力            | 中等                      | 丰富（内置 utils）|
| 生态成熟度          | 较高（Facebook 出品）| 快速增长                  |
| 兼容性              | 兼容 React 16.8+          | 兼容 React 16.8+          |

# 4. 轻量状态管理方案选择建议
1. **选 Recoil**：
   - 项目已深度使用 Recoil 生态；
   - 依赖 Recoil 特有功能（如原子家族、持久化快照）；
   - 团队更信任 Facebook 官方维护的库。

2. **选 Jotai**：
   - 追求极简 API 和更小体积；
   - 不想引入 Provider 层级；
   - 需丰富的内置扩展（持久化、批量更新等）；
   - 中小型 React 项目，优先轻量高效。

3. **选 Zustand**：
   - 需集中式 store 管理（而非原子化）；
   - 无需兼容 Suspense/并发模式；
   - 追求跨组件状态共享的极致简洁。
', '7a39499e-a54e-4dd5-89ed-f24202ec0992', 'true', '2025-12-22 03:14:11.255705+00', '2025-12-23 09:09:27.870864+00'), ('5981c8dd-28c7-4598-b29b-aff7d40e34c1', 'React 项目部署', '# 1. 部署前准备
## 1.1 生产环境打包
```bash
npm run build
```
打包完成后生成 `build`（CRA）/ `dist`（Vite/Webpack）目录，包含静态资源（HTML/CSS/JS/图片）。

## 1.2 打包产物检查
- 确认 `index.html` 为入口文件；
- 检查静态资源路径（相对路径/绝对路径）：
  - 相对路径：适合部署在子路径（如 `https://example.com/app/`）；
  - 绝对路径：适合部署在根路径（如 `https://example.com/`）；
- 配置基础路径（Base URL）：
  - CRA：修改 `package.json` 中的 `homepage`：
    ```json
    { "homepage": "https://example.com/app/" }
    ```
  - Vite：修改 `vite.config.js` 中的 `base`：
    ```javascript
    export default defineConfig({ base: ''/app/'' });
    ```
  - Webpack：修改 `webpack.config.js` 中的 `output.publicPath`：
    ```javascript
    output: { publicPath: ''/app/'' }
    ```

# 2. Nginx 部署（本地/服务器）
## 2.1 Nginx 安装
- **Windows**：下载 Nginx 压缩包，解压后运行 `nginx.exe`；
- **Linux**：`sudo apt install nginx`（Ubuntu/Debian）或 `sudo yum install nginx`（CentOS）；
- **Mac**：`brew install nginx`。

## 2.2 配置 Nginx
1. 复制打包产物到 Nginx 静态目录（默认 `/usr/share/nginx/html`，Windows 为 `nginx-xxx/html`）；
2. 修改 Nginx 配置文件（默认 `/etc/nginx/nginx.conf` 或 `nginx-xxx/conf/nginx.conf`）：
   ```nginx
   server {
     listen 80; # 监听端口
     server_name localhost; # 域名（生产环境改为实际域名）

     # 静态资源根目录
     root /usr/share/nginx/html;
     index index.html;

     # 支持 React Router 路由（刷新 404 问题）
     location / {
       try_files $uri $uri/ /index.html; # 找不到文件时返回 index.html
     }

     # 静态资源缓存策略
     location ~* \.(js|css|png|jpg|jpeg|gif|svg)$ {
       expires 30d; # 30 天缓存
       add_header Cache-Control "public, max-age=2592000";
     }

     # gzip 压缩（提升加载速度）
     gzip on;
     gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
   }
   ```

## 2.3 启动/重启 Nginx
```bash
sudo nginx # 启动（Linux/Mac）

sudo nginx -s reload  # 重启（修改配置后）

sudo nginx -s stop # 停止

nginx.exe -s reload # Windows
```

## 2.4 访问项目
打开浏览器访问 `http://localhost`（或服务器 IP/域名），确认项目正常运行。

## 2.5 生产环境优化（Nginx）
1. **HTTPS 配置**（Let''s Encrypt 免费证书）：
   ```bash
   # 安装 certbot
   sudo apt install certbot python3-certbot-nginx
   # 获取证书并配置 Nginx
   sudo certbot --nginx -d example.com
   ```
2. **开启 gzip 压缩**（已在配置中示例）；
3. **限制请求速率**（防止攻击）：
   ```nginx
   limit_req_zone $binary_remote_addr zone=one:10m rate=10r/s;
   location / {
     limit_req zone=one burst=20 nodelay;
   }
   ```

# 3. Vercel 部署（前端无服务部署）
Vercel 是 Vite 官方推荐的部署平台，支持一键部署、自动构建、免费 HTTPS、全球 CDN。

## 3.1 部署步骤
1. 注册 Vercel 账号（关联 GitHub/GitLab/Bitbucket）；
2. 安装 Vercel CLI（可选）：
   ```bash
   npm install -g vercel
   ```
3. 方式一：GitHub 仓库关联部署
   - 将项目推送到 GitHub 仓库；
   - 登录 Vercel → New Project → 导入仓库 → 配置构建命令：
     - Framework Preset：React / Vite（自动识别）；
     - Build Command：`npm run build`；
     - Output Directory：`build`（CRA）/ `dist`（Vite/Webpack）；
   - 点击 Deploy，等待部署完成。
4. 方式二：CLI 部署（本地直接部署）
   ```bash
   cd 项目根目录
   vercel （首次部署需登录，按提示操作）
   vercel --prod （部署到生产环境）
   ```

## 3.2 关键配置
1. **Vercel.json**（项目根目录）：
   ```json
   {
     "rewrites": [{ "source": "/(.*)", "destination": "/index.html" }], // 支持 React Router
     "build": {
       "env": {
         "NODE_ENV": "production"
       }
     }
   }
   ```
2. **环境变量配置**：Vercel 控制台 → Project → Settings → Environment Variables，添加生产环境变量（如 API 地址）。

## 3.3 优势
- 免费额度充足（个人版）；
- 自动 HTTPS + 全球 CDN；
- 支持预览部署（PR 自动生成预览链接）；
- 零配置部署（自动识别框架）。

# 4. Netlify 部署（替代 Vercel）
Netlify 与 Vercel 功能类似，支持静态站点和 Serverless 部署。

## 4.1 部署步骤
1. 注册 Netlify 账号（关联 GitHub/GitLab/Bitbucket）；
2. 方式一：仓库关联部署
   - Netlify → Add new site → Import an existing project → 选择 GitHub 仓库；
   - 配置构建参数：
     - Build command：`npm run build`；
     - Publish directory：`build`/`dist`；
   - 点击 Deploy site。
3. 方式二：手动上传部署
   - Netlify → Add new site → Deploy manually → 拖放 `build`/`dist` 目录 → 部署。

## 4.2 关键配置
1. **Netlify.toml**（项目根目录）：
   ```toml
   [build]
     command = "npm run build"
     publish = "dist"
   [[redirects]]
     from = "/*"
     to = "/index.html"
     status = 200 # 支持 React Router 路由
   ```
2. **环境变量**：Netlify 控制台 → Site settings → Build & deploy → Environment → Environment variables。

# 5. 部署常见问题解决
## 5.1 路由刷新 404
- 原因：React Router 是客户端路由，刷新时服务器找不到对应路径的文件；
- 解决：
  - Nginx：配置 `try_files $uri $uri/ /index.html`；
  - Vercel/Netlify：配置重写规则（rewrites/redirects）指向 `index.html`。

## 5.2 静态资源加载失败
- 检查 `publicPath`/`base` 配置是否正确；
- 确认静态资源路径为相对路径（如 `./static/js/main.js`）或绝对路径（如 `/static/js/main.js`）；
- 检查 CDN 引入的依赖是否加载成功（控制台 Network 面板）。

## 5.3 环境变量未生效
- 生产环境环境变量需在部署平台（Vercel/Netlify/Nginx）配置；
- React 项目中环境变量需以 `REACT_APP_`（CRA）/ `VITE_`（Vite）开头；
- 打包前重启构建命令，确保环境变量注入。

## 5.4 跨域问题
- 开发环境：使用代理（Vite `server.proxy` / Webpack `devServer.proxy`）；
- 生产环境：
  - 后端配置 CORS（允许前端域名）；
  - Nginx 反向代理（将前端 API 请求转发到后端）：
    ```nginx
    location /api/ {
      proxy_pass http://backend-server:8080/; # 后端接口地址
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
    }
    ```

# 6. 部署后监控与维护
1. **访问统计**：集成 Google Analytics 或百度统计；
2. **错误监控**：使用 Sentry 捕获前端错误；
3. **CI/CD 自动化部署**：
   - GitHub Actions：配置推送代码自动部署到 Vercel/Netlify；
   - 示例（GitHub Actions 部署到 Vercel）：
     ```yaml
     # .github/workflows/vercel.yml
     name: Deploy to Vercel
     on:
       push:
         branches: [main]
     jobs:
       deploy:
         runs-on: ubuntu-latest
         steps:
           - uses: actions/checkout@v3
           - uses: actions/setup-node@v3
             with: { node-version: 18 }
           - run: npm install
           - run: npm run build
           - uses: amondnet/vercel-action@v20
             with:
               vercel-token: ${{ secrets.VERCEL_TOKEN }}
               vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
               vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
               vercel-args: ''--prod''
     ```

# 7. 部署方案对比
| 部署方案 | 优点 | 缺点 | 适用场景 |
|----------|------|------|----------|
| Nginx | 完全可控、自定义配置、高性能 | 需服务器、维护成本高 | 企业级项目、需自定义服务器配置 |
| Vercel | 零配置、自动部署、全球 CDN、免费 | 高级功能付费、依赖第三方平台 | 个人项目、中小型前端项目 |
| Netlify | 功能全面、免费额度高、支持 Serverless | 国内访问速度一般 | 个人项目、静态站点 |', '4e45758d-1053-4937-b961-5a3cef9e566a', 'true', '2025-12-22 03:21:02.868678+00', '2025-12-23 14:04:30.046185+00'), ('5c2e2d6e-eb44-48d2-9743-b6b80f96be35', '懒加载与代码分割', '# 1. 为什么需要代码分割
React 项目默认使用打包工具（Webpack/Rollup）将所有代码打包为一个或少数几个文件，存在以下问题：
- **首屏加载慢**：打包文件体积过大，导致页面首次加载时间长（白屏）；
- **资源浪费**：用户可能只访问部分功能（如首页、详情页），但加载了所有功能的代码；
- **性能瓶颈**：大体积 JS 文件解析/执行耗时，阻塞页面渲染。

## 1.1 代码分割的核心思想
将应用代码按功能/路由拆分为多个小块（chunk），**按需加载**（仅当用户访问对应功能时才加载相关代码），实现：
- 减小首屏加载体积，提升加载速度；
- 避免加载未使用的代码，节省带宽；
- 并行加载多个小块，提升整体性能。

# 2. React.lazy：组件级懒加载
React.lazy 是 React 内置的懒加载 API，用于动态导入组件（仅在组件需要渲染时才加载对应的代码块），配合 `import()` 语法实现代码分割。

## 2.1 基本用法
```javascript
// 传统导入（同步加载，打包到主文件）
import Home from ''./pages/Home'';

// 懒加载导入（异步加载，单独打包为 chunk）
const About = React.lazy(() => import(''./pages/About''));
const Contact = React.lazy(() => import(''./pages/Contact''));

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Home />} />
        {/* 懒加载组件需包裹在 Suspense 中 */}
        <Route path="/about" element={
          <Suspense fallback={<div>Loading...</div>}>
            <About />
          </Suspense>
        } />
        <Route path="/contact" element={
          <Suspense fallback={<div>Loading...</div>}>
            <Contact />
          </Suspense>
        } />
      </Routes>
    </Router>
  );
}
```

## 2.2 核心细节
1. **React.lazy 参数**：必须是返回 Promise 的函数，且 Promise 需解析为默认导出的 React 组件；
2. **Suspense 依赖**：懒加载组件渲染时，代码块可能尚未加载完成，需用 `Suspense` 包裹，通过 `fallback` 属性显示加载占位符（如骨架屏、加载动画）；
3. **错误处理**：若代码块加载失败（如网络错误），需用错误边界（Error Boundary）捕获异常；
4. **打包行为**：Webpack 等工具会自动将 `import()` 导入的模块拆分为独立 chunk，文件名默认包含哈希（如 `about.123abc.js`）。

## 2.3 高级用法：命名导出组件
React.lazy 默认只支持默认导出（default export），若组件是命名导出，需手动包装：
```javascript
// 组件文件（pages/Product.js）
export const ProductList = () => <div>Product List</div>;
export const ProductDetail = () => <div>Product Detail</div>;

// 懒加载命名导出组件
const ProductList = React.lazy(() => 
  import(''./pages/Product'').then(module => ({
    default: module.ProductList // 映射为默认导出
  }))
);
```

# 3. Suspense：加载状态管理
Suspense 是 React 提供的加载状态管理组件，核心功能是：**在组件加载完成前显示 fallback 占位符**，支持以下场景：
1. 配合 React.lazy 实现组件懒加载；
2. 配合 Suspense 兼容的数据源（如 React Query、Relay）实现数据懒加载；
3. 嵌套使用，实现多级加载占位符。

## 3.1 核心特性
1. **fallback 属性**：必填，接收 React 元素（如加载动画、骨架屏），在组件加载完成前显示；
2. **嵌套 Suspense**：内层 Suspense 的 fallback 优先级高于外层，实现精细化加载状态控制；
   ```jsx
   <Suspense fallback={<div>Page Loading...</div>}>
     <About />
     <Suspense fallback={<div>Comments Loading...</div>}>
       <Comments /> {/* 独立懒加载的子组件 */}
     </Suspense>
   </Suspense>
   ```
3. **并发模式支持**：在 React 18 并发模式下，Suspense 可实现“流式渲染”（先渲染已加载的内容，再逐步渲染未加载的内容）。

# 4. 路由级代码分割（最佳实践）
最常用的代码分割策略是按路由拆分，因为路由切换是天然的“按需加载”触发点，实现步骤：
1. 使用 React.lazy 懒加载路由组件；
2. 用 Suspense 包裹路由组件，设置全局加载占位符；
3. （可选）添加错误边界处理加载失败；

## 4.1 完整示例
```javascript
import { BrowserRouter as Router, Routes, Route } from ''react-router-dom'';
import { Suspense, lazy } from ''react'';
import ErrorBoundary from ''./components/ErrorBoundary'';
import Loading from ''./components/Loading''; // 自定义加载组件

// 同步加载核心组件
import Header from ''./components/Header'';
import Footer from ''./components/Footer'';

// 懒加载路由组件
const Home = lazy(() => import(''./pages/Home''));
const About = lazy(() => import(''./pages/About''));
const Products = lazy(() => import(''./pages/Products''));
const NotFound = lazy(() => import(''./pages/NotFound''));

function App() {
  return (
    <Router>
      <Header />
      {/* 全局 Suspense：所有懒加载路由共用一个加载占位符 */}
      <ErrorBoundary fallback={<div>Oops! Something went wrong.</div>}>
        <Suspense fallback={<Loading />}>
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/about" element={<About />} />
            <Route path="/products/*" element={<Products />} />
            <Route path="*" element={<NotFound />} />
          </Routes>
        </Suspense>
      </ErrorBoundary>
      <Footer />
    </Router>
  );
}
```

# 5. 代码分割的进阶优化
## 5.1 预加载（Preloading）
在用户可能访问的路由（如 hover 导航链接时）提前加载代码块，提升用户体验：
```javascript
const About = React.lazy(() => import(''./pages/About''));

function NavLink() {
  const handleHover = () => {
    // 预加载 About 组件代码块
    import(''./pages/About'');
  };

  return (
    <a href="/about" onMouseEnter={handleHover}>
      About
    </a>
  );
}
```

## 5.2 公共代码提取
通过打包工具（Webpack）提取多个 chunk 共享的代码（如 React、React DOM）为公共 chunk，避免重复加载：
```javascript
// webpack.config.js
module.exports = {
  optimization: {
    splitChunks: {
      chunks: ''all'', // 提取所有 chunk 的公共代码
      cacheGroups: {
        vendor: {
          test: /[\\/]node_modules[\\/]/, // 匹配 node_modules 中的依赖
          name: ''vendors'', // 公共 chunk 名称
          priority: -10 // 优先级
        }
      }
    }
  }
};
```

## 5.3 动态导入的魔法注释（Webpack 专属）
通过魔法注释自定义 chunk 名称、设置预加载等：
```javascript
const About = React.lazy(() => 
  import(/* webpackChunkName: "about-page" */ ''./pages/About'')
);

// 预加载 chunk（webpackPrefetch: true）
const Products = React.lazy(() => 
  import(/* webpackChunkName: "products-page", webpackPrefetch: true */ ''./pages/Products'')
);
```
- `webpackChunkName`：自定义 chunk 名称（便于调试）；
- `webpackPrefetch`：在浏览器空闲时预加载 chunk；
- `webpackPreload`：与当前 chunk 并行加载（适用于立即需要的 chunk）。

# 6. 注意事项
1. **不要过度分割**：过小的 chunk 会增加 HTTP 请求数量（HTTP/1.1 下），建议按路由/大型功能模块分割；
2. **HTTP/2 支持**：HTTP/2 支持多路复用，可优化多 chunk 加载性能，建议配合使用；
3. **服务端渲染（SSR）**：React.lazy 不支持 SSR，需使用 `loadable-components` 替代；
4. **加载状态设计**：fallback 占位符应简洁（如骨架屏），避免加载过程中出现布局偏移（CLS）。

# 7. 替代方案：loadable-components
若项目需要 SSR 支持或更灵活的懒加载控制，可使用第三方库 `@loadable/component`：
```bash
npm install @loadable/component
```

```javascript
import loadable from ''@loadable/component'';
import Loading from ''./components/Loading'';

// 懒加载组件（支持 SSR）
const About = loadable(() => import(''./pages/About''), {
  fallback: <Loading />
});
```', '46554425-2ee6-405b-b46c-7720d50c48ec', 'true', '2025-12-22 03:15:15.281929+00', '2025-12-23 09:34:05.084227+00'), ('602ea56d-4786-4a58-bb2a-cb6eb7f1d9c9', '受控表单', '# 1. 受控表单的核心概念
React 中的**受控表单**是指表单元素的值由 React 组件状态（`state`）完全控制，表单元素的更新（如输入、选择）会同步修改状态，状态变化后又会反向更新表单元素的显示值。这种“状态-视图”双向绑定的模式，让表单数据的管理更可控、可预测，是 React 表单处理的推荐方式。

## 核心特征
- 表单元素的值绑定到组件 `state`；
- 通过 `onChange` 事件监听表单元素的变化，同步更新 `state`；
- 表单元素的显示值始终与 `state` 保持一致；
- 可直接通过修改 `state` 控制表单元素（如重置、预填）。

# 2. 常见表单元素的受控实现
## 2.1 文本输入框（input[type="text"]）
最基础的受控表单元素，通过 `value` 绑定状态，`onChange` 同步输入内容。

```javascript
import { useState } from ''react'';

function TextInput() {
  // 初始化状态，绑定输入框值
  const [username, setUsername] = useState('''');

  // 监听输入变化，同步更新状态
  const handleUsernameChange = (e) => {
    setUsername(e.target.value);
  };

  // 表单提交处理
  const handleSubmit = (e) => {
    e.preventDefault(); // 阻止默认表单提交行为
    console.log(''提交的用户名：'', username);
    // 后续逻辑：接口请求、数据处理等
  };

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <label>用户名：</label>
        {/* value 绑定 state，onChange 绑定事件 */}
        <input
          type="text"
          value={username}
          onChange={handleUsernameChange}
          placeholder="请输入用户名"
        />
      </div>
      <button type="submit">提交</button>
    </form>
  );
}
```

## 2.2 密码框（input[type="password"]）
与文本输入框逻辑一致，仅 `type` 属性不同。

```javascript
function PasswordInput() {
  const [password, setPassword] = useState('''');

  const handlePasswordChange = (e) => {
    setPassword(e.target.value);
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log(''提交的密码：'', password);
  };

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <label>密码：</label>
        <input
          type="password"
          value={password}
          onChange={handlePasswordChange}
          placeholder="请输入密码"
        />
      </div>
      <button type="submit">提交</button>
    </form>
  );
}
```

## 2.3 单选按钮（input[type="radio"]）
多个单选按钮需绑定同一个状态，通过 `name` 属性分组，`value` 属性区分选项，选中时同步状态为对应 `value`。

```javascript
function RadioGroup() {
  // 初始化状态（默认选中“male”）
  const [gender, setGender] = useState(''male'');

  const handleGenderChange = (e) => {
    setGender(e.target.value);
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log(''选择的性别：'', gender);
  };

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <label>性别：</label>
        <input
          type="radio"
          name="gender" // 同一组单选按钮 name 必须一致
          value="male"
          checked={gender === ''male''} // 绑定选中状态
          onChange={handleGenderChange}
        />
        <span>男</span>
        <input
          type="radio"
          name="gender"
          value="female"
          checked={gender === ''female''}
          onChange={handleGenderChange}
        />
        <span>女</span>
      </div>
      <button type="submit">提交</button>
    </form>
  );
}
```

## 2.4 复选框（input[type="checkbox"]）
复选框分两种场景：单个复选框（布尔值）、多个复选框（数组存储选中值）。

### 场景 1：单个复选框（如“同意协议”）
```javascript
function SingleCheckbox() {
  const [agreed, setAgreed] = useState(false); // 布尔值状态

  const handleAgreeChange = (e) => {
    setAgreed(e.target.checked); // 绑定 checked 属性
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log(''是否同意协议：'', agreed);
  };

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <input
          type="checkbox"
          id="agree"
          checked={agreed}
          onChange={handleAgreeChange}
        />
        <label htmlFor="agree">我已阅读并同意用户协议</label>
      </div>
      {/* 未同意时禁用提交按钮 */}
      <button type="submit" disabled={!agreed}>提交</button>
    </form>
  );
}
```

### 场景 2：多个复选框（如“兴趣爱好”）
```javascript
function MultiCheckbox() {
  // 兴趣选项数据
  const hobbies = [
    { id: ''sports'', name: ''运动'' },
    { id: ''reading'', name: ''阅读'' },
    { id: ''coding'', name: ''编程'' },
    { id: ''music'', name: ''音乐'' }
  ];
  // 数组状态存储选中的兴趣 ID
  const [selectedHobbies, setSelectedHobbies] = useState([]);

  const handleHobbyChange = (e) => {
    const hobbyId = e.target.value;
    // 判断当前选项是否已选中，更新数组
    if (selectedHobbies.includes(hobbyId)) {
      // 已选中：从数组中移除
      setSelectedHobbies(selectedHobbies.filter(id => id !== hobbyId));
    } else {
      // 未选中：添加到数组
      setSelectedHobbies([...selectedHobbies, hobbyId]);
    }
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log(''选择的兴趣：'', selectedHobbies);
    // 映射为中文名称（可选）
    const selectedNames = hobbies
      .filter(hobby => selectedHobbies.includes(hobby.id))
      .map(hobby => hobby.name);
    console.log(''兴趣名称：'', selectedNames);
  };

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <label>兴趣爱好：</label>
        {hobbies.map((hobby) => (
          <div key={hobby.id}>
            <input
              type="checkbox"
              id={hobby.id}
              value={hobby.id}
              // 判断是否选中
              checked={selectedHobbies.includes(hobby.id)}
              onChange={handleHobbyChange}
            />
            <label htmlFor={hobby.id}>{hobby.name}</label>
          </div>
        ))}
      </div>
      <button type="submit">提交</button>
    </form>
  );
}
```

## 2.5 下拉选择框（select）
分为单选下拉框和多选下拉框，通过 `value` 绑定状态，`onChange` 同步选中值。

### 场景 1：单选下拉框
```javascript
function SingleSelect() {
  // 选项数据
  const cities = [
    { id: ''beijing'', name: ''北京'' },
    { id: ''shanghai'', name: ''上海'' },
    { id: ''guangzhou'', name: ''广州'' },
    { id: ''shenzhen'', name: ''深圳'' }
  ];
  // 初始化状态（默认选中“beijing”）
  const [selectedCity, setSelectedCity] = useState(''beijing'');

  const handleCityChange = (e) => {
    setSelectedCity(e.target.value);
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log(''选择的城市：'', selectedCity);
  };

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <label>城市：</label>
        <select value={selectedCity} onChange={handleCityChange}>
          {cities.map((city) => (
            <option key={city.id} value={city.id}>
              {city.name}
            </option>
          ))}
        </select>
      </div>
      <button type="submit">提交</button>
    </form>
  );
}
```

### 场景 2：多选下拉框（multiple）
需给 `select` 添加 `multiple` 属性，状态为数组类型。

```javascript
function MultiSelect() {
  const fruits = [
    { id: ''apple'', name: ''苹果'' },
    { id: ''banana'', name: ''香蕉'' },
    { id: ''orange'', name: ''橙子'' },
    { id: ''grape'', name: ''葡萄'' }
  ];
  // 数组状态存储选中的水果 ID
  const [selectedFruits, setSelectedFruits] = useState([]);

  const handleFruitChange = (e) => {
    // 多选下拉框的选中值需通过 e.target.selectedOptions 获取
    const selectedOptions = Array.from(e.target.selectedOptions);
    const selectedIds = selectedOptions.map(option => option.value);
    setSelectedFruits(selectedIds);
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log(''选择的水果：'', selectedFruits);
  };

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <label>水果（按住 Ctrl 多选）：</label>
        <select
          multiple
          value={selectedFruits}
          onChange={handleFruitChange}
          style={{ height: ''100px'' }} // 调整高度，方便多选
        >
          {fruits.map((fruit) => (
            <option key={fruit.id} value={fruit.id}>
              {fruit.name}
            </option>
          ))}
        </select>
      </div>
      <button type="submit">提交</button>
    </form>
  );
}
```

## 2.6 文本域（textarea）
与文本输入框逻辑一致，`value` 绑定状态，`onChange` 同步输入内容（无需手动设置 `rows`/`cols`，可通过 CSS 控制样式）。

```javascript
function TextArea() {
  const [intro, setIntro] = useState(''''); // 初始化为空字符串

  const handleIntroChange = (e) => {
    setIntro(e.target.value);
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log(''个人简介：'', intro);
  };

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <label>个人简介：</label>
        <textarea
          value={intro}
          onChange={handleIntroChange}
          placeholder="请输入个人简介"
          style={{ width: ''300px'', height: ''150px'' }}
        />
      </div>
      <button type="submit">提交</button>
    </form>
  );
}
```

# 3. 复杂表单：多字段统一管理
实际开发中表单通常包含多个字段，可将所有字段状态整合到一个对象中，通过统一的事件处理函数同步更新，简化代码。

```javascript
import { useState } from ''react'';

function ComplexForm() {
  // 整合所有字段状态到一个对象
  const [formData, setFormData] = useState({
    username: '''',
    password: '''',
    gender: ''male'',
    hobbies: [],
    city: ''beijing'',
    intro: ''''
  });

  // 统一的字段更新函数（通过 name 属性匹配字段）
  const handleInputChange = (e) => {
    const { name, value, type, checked } = e.target;
    // 根据表单元素类型处理值（复选框特殊处理）
    setFormData(prev => ({
      ...prev,
      [name]: type === ''checkbox'' ? checked : value
    }));
  };

  // 单独处理多复选框（兴趣爱好）
  const handleHobbyChange = (e) => {
    const hobbyId = e.target.value;
    setFormData(prev => ({
      ...prev,
      hobbies: prev.hobbies.includes(hobbyId)
        ? prev.hobbies.filter(id => id !== hobbyId)
        : [...prev.hobbies, hobbyId]
    }));
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log(''表单提交数据：'', formData);
    // 后续：接口请求、表单重置等
  };

  // 表单重置（直接修改 state 即可）
  const handleReset = () => {
    setFormData({
      username: '''',
      password: '''',
      gender: ''male'',
      hobbies: [],
      city: ''beijing'',
      intro: ''''
    });
  };

  return (
    <form onSubmit={handleSubmit} style={{ display: ''flex'', flexDirection: ''column'', gap: ''10px'' }}>
      {/* 用户名 */}
      <div>
        <label>用户名：</label>
        <input
          type="text"
          name="username" // name 需与 state 字段名一致
          value={formData.username}
          onChange={handleInputChange}
          placeholder="请输入用户名"
        />
      </div>

      {/* 密码 */}
      <div>
        <label>密码：</label>
        <input
          type="password"
          name="password"
          value={formData.password}
          onChange={handleInputChange}
          placeholder="请输入密码"
        />
      </div>

      {/* 性别（单选） */}
      <div>
        <label>性别：</label>
        <input
          type="radio"
          name="gender"
          value="male"
          checked={formData.gender === ''male''}
          onChange={handleInputChange}
        />
        <span>男</span>
        <input
          type="radio"
          name="gender"
          value="female"
          checked={formData.gender === ''female''}
          onChange={handleInputChange}
        />
        <span>女</span>
      </div>

      {/...', '0e360aa6-df1e-4212-b06e-7ebc4541f5d5', 'true', '2025-12-22 03:18:25.47063+00', '2025-12-23 12:59:46.897083+00'), ('60790d46-4f56-4f12-87de-9e4098ed8496', 'Zustand 入门', 'Zustand 是一款轻量级 React 状态管理库，以“简洁 API、无 Provider 嵌套、高性能”为核心优势，相比 Redux 更易上手，相比 Context API 更高效，适合中小型项目及需要灵活状态管理的场景。本文将从基础入门，带你掌握 Zustand 的核心使用流程。

# 1. 环境准备：安装 Zustand
## 1.1 基本安装
通过 npm/yarn/pnpm 安装核心依赖（支持 React 16.8+）：
```bash
npm
npm install zustand

yarn
yarn add zustand

pnpm
pnpm add zustand
```

## 1.2 可选依赖（按需安装）
- 类型提示：Zustand 原生支持 TypeScript，无需额外依赖；
- 持久化：需安装 `zustand/middleware`（内置持久化中间件）；
- 开发工具：需安装 Redux DevTools 扩展（支持 Zustand 状态调试）。

# 2. 核心概念：Store
Store 是 Zustand 中存储状态的容器，本质是一个包含“状态数据”和“修改状态的方法”的对象。通过 `create` 函数创建 Store，整个应用可创建多个独立 Store（无需全局统一管理）。

## 2.1 创建第一个 Store
新建 `stores/counterStore.js`（或 `.ts`）文件，通过 `create` 函数定义 Store：
```jsx
// stores/counterStore.js
import { create } from ''zustand'';

// 创建 Store：参数为一个函数，返回 { 状态, 状态修改方法 }
const useCounterStore = create((set) => ({
  // 1. 定义状态
  count: 0,
  username: ''Zustand 新手'',

  // 2. 定义修改状态的方法（通过 set 函数更新状态）
  increment: () => set((state) => ({ count: state.count + 1 })), // 函数式更新（依赖旧状态）
  decrement: () => set((state) => ({ count: state.count - 1 })),
  setUsername: (newName) => set({ username: newName }), // 直接更新（不依赖旧状态）
  reset: () => set({ count: 0, username: ''Zustand 新手'' }), // 批量更新多个状态
}));

export default useCounterStore;
```

### 2.2 关键说明
- `create` 函数：接收一个“初始化函数”，返回一个自定义 Hook（如 `useCounterStore`），组件通过该 Hook 访问 Store；
- `set` 函数：用于修改状态，支持两种写法：
  - 直接传递新状态对象：`set({ key: newValue })`（适用于不依赖旧状态的场景）；
  - 传递函数：`set((state) => ({ key: state.key + 1 }))`（适用于依赖旧状态的场景，避免竞态问题）；
- Store 独立隔离：每个 `create` 调用创建一个独立 Store，互不影响（支持按业务模块拆分 Store）。

## 2.2 组件中使用 Store：useStore 用法
组件通过自定义 Hook（如 `useCounterStore`）访问 Store，支持“获取单个状态”“获取多个状态”“调用状态修改方法”三种核心场景。

### 场景 1：获取单个状态（推荐，性能最优）
通过 `useStore((state) => state.xxx)` 精准获取单个状态，Zustand 会自动优化重渲染（仅当该状态变化时，组件才重渲染）：
```jsx
// components/Counter.jsx
import useCounterStore from ''../stores/counterStore'';

export default function Counter() {
  // 获取单个状态：仅当 count 变化时，组件重渲染
  const count = useCounterStore((state) => state.count);
  const username = useCounterStore((state) => state.username);

  return (
    <div>
      <h2>用户名：{username}</h2>
      <p>当前计数：{count}</p>
    </div>
  );
}
```

### 场景 2：获取多个状态（避免多次调用 useStore）
若需获取多个状态，可通过“选择器函数返回对象”的方式，但需配合 `shallow` 比较（否则组件会因对象引用变化而频繁重渲染）：
```jsx
import { shallow } from ''zustand/shallow'';
import useCounterStore from ''../stores/counterStore'';

export default function Counter() {
  // 方式 1：使用 shallow 比较（推荐）
  const { count, username } = useCounterStore(
    (state) => ({ count: state.count, username: state.username }),
    shallow // 浅层比较：仅当 count 或 username 实际变化时重渲染
  );

  // 方式 2：分多次调用 useStore（性能等价，写法更简洁）
  // const count = useCounterStore((state) => state.count);
  // const username = useCounterStore((state) => state.username);

  return (
    <div>
      <h2>用户名：{username}</h2>
      <p>当前计数：{count}</p>
    </div>
  );
}
```

### 场景 3：调用 Store 中的方法（修改状态）
直接通过 `useStore` 获取 Store 中的方法，调用后自动更新状态并触发依赖组件重渲染：
```jsx
import useCounterStore from ''../stores/counterStore'';

export default function Counter() {
  const count = useCounterStore((state) => state.count);
  // 获取状态修改方法
  const increment = useCounterStore((state) => state.increment);
  const decrement = useCounterStore((state) => state.decrement);
  const setUsername = useCounterStore((state) => state.setUsername);
  const reset = useCounterStore((state) => state.reset);

  return (
    <div>
      <h2>用户名：{useCounterStore((state) => state.username)}</h2>
      <p>当前计数：{count}</p>
      <button onClick={increment}>+1</button>
      <button onClick={decrement}>-1</button>
      <button onClick={() => setUsername(''Zustand 高手'')}>修改用户名</button>
      <button onClick={reset}>重置</button>
    </div>
  );
}
```

### 场景 4：获取整个 Store（不推荐，性能较差）
直接调用 `useStore()` 可获取整个 Store 对象，但组件会因 Store 中任意状态变化而重渲染，仅适用于调试或简单场景：
```jsx
const store = useCounterStore();
console.log(store.count); // 访问状态
store.increment(); // 调用方法
```

# 3. 入门关键注意事项
1. **无需 Provider 包裹**：Zustand 不依赖 React Context，创建 Store 后可直接在任意组件中使用，无需像 Redux/Context 那样包裹顶层 Provider；
2. **重渲染优化**：获取状态时尽量“精准选择单个状态”或使用 `shallow` 比较，避免因无关状态变化导致组件不必要重渲染；
3. **状态修改的不可变性**：`set` 函数内部会自动处理状态的不可变性（无需手动深拷贝），直接返回新状态即可；
4. **组件卸载后的状态安全**：若组件卸载后仍有异步操作尝试修改状态，Zustand 会自动忽略，无需手动清理订阅；
5. **调试支持**：默认支持 Redux DevTools，安装扩展后可直接查看状态变化记录（下文核心特性会详细说明）。

# 4. 入门示例完整代码
## 4.1 Store 定义（stores/counterStore.js）
```jsx
import { create } from ''zustand'';

const useCounterStore = create((set) => ({
  count: 0,
  username: ''Zustand 新手'',
  increment: () => set((state) => ({ count: state.count + 1 })),
  decrement: () => set((state) => ({ count: state.count - 1 })),
  setUsername: (newName) => set({ username: newName }),
  reset: () => set({ count: 0, username: ''Zustand 新手'' }),
}));

export default useCounterStore;
```

## 4.2 组件使用（components/Counter.jsx）
```jsx
import { shallow } from ''zustand/shallow'';
import useCounterStore from ''../stores/counterStore'';

export default function Counter() {
  // 获取状态（浅层比较多个状态）
  const { count, username } = useCounterStore(
    (state) => ({ count: state.count, username: state.username }),
    shallow
  );

  // 获取方法
  const { increment, decrement, setUsername, reset } = useCounterStore(
    (state) => ({
      increment: state.increment,
      decrement: state.decrement,
      setUsername: state.setUsername,
      reset: state.reset,
    }),
    shallow // 方法引用不会变化，可省略 shallow，但加上更规范
  );

  return (
    <div style={{ padding: ''20px'' }}>
      <h2>Zustand 入门示例</h2>
      <p>用户名：{username}</p>
      <p>当前计数：{count}</p>
      <button onClick={increment} style={{ marginRight: ''8px'' }}>+1</button>
      <button onClick={decrement} style={{ marginRight: ''8px'' }}>-1</button>
      <button onClick={() => setUsername(''Zustand 高手'')} style={{ marginRight: ''8px'' }}>
        修改用户名
      </button>
      <button onClick={reset}>重置</button>
    </div>
  );
}
```', 'ed2cdaf2-c966-4d9f-bfad-740b9f352c61', 'true', '2025-12-22 03:10:22.068941+00', '2025-12-23 03:11:05.21255+00'), ('622728a4-0cb0-49e1-b9ae-1c891dea8d91', 'React Query/SWR', '# 1. 核心价值：替代传统数据管理方案
传统 React 项目中，数据请求需手动处理「加载状态、缓存、刷新、错误处理」，代码冗余且易出错。React Query（现更名为 TanStack Query）和 SWR（Next.js 团队开发）是专注于**服务端状态管理**的库，核心优势：
- 自动缓存：相同请求数据缓存，避免重复请求；
- 智能刷新：后台静默刷新、窗口聚焦刷新、定时刷新；
- 状态管理：内置加载/错误/成功状态，无需手动维护 `useState`；
- 乐观更新：先更新 UI 再同步接口，提升用户体验；
- 分页/无限滚动：简化列表数据加载逻辑；
- 与 Axios 无缝集成：复用已封装的接口请求。

# 2. 选型对比：React Query vs SWR
| 特性                | React Query（TanStack Query）                | SWR（Stale-While-Revalidate）                |
|---------------------|----------------------------------------------|----------------------------------------------|
| 核心理念            | 全面的服务端状态管理（缓存、查询、突变）      | 基于「陈旧数据可用 + 后台刷新」策略           |
| API 设计            | 更丰富（`useQuery`/`useMutation`/`useInfiniteQuery`） | 更简洁（`useSWR` 一站式处理查询与突变）       |
| 缓存机制            | 多维度缓存（键、标签、失效时间）              | 基于键的简单缓存，支持自定义重新验证          |
| 功能丰富度          | 极高（分页、无限滚动、预取、查询失效）        | 轻量（核心功能完善，扩展需自定义）            |
| 学习成本            | 中（API 较多，配置项丰富）                    | 低（API 简洁，上手快）                        |
| 适用场景            | 复杂中后台系统（多列表、多筛选、频繁更新）    | 中小型项目、Next.js 生态项目（原生支持）      |
| 体积                | 稍大（核心包 ~15KB）                          | 极小（~5KB）                                  |

# 3. React Query 实战（推荐中后台项目）
## 3.1 环境搭建
```bash
npm install @tanstack/react-query @tanstack/react-query-devtools # 安装核心依赖（React Query v5+）

npm install @tanstack/react-query-persist-client # 如需分页/无限滚动，安装扩展
```

## 3.2 步骤 1：全局配置（src/providers/QueryProvider.tsx）
```tsx
import React from ''react'';
import { QueryClient, QueryClientProvider } from ''@tanstack/react-query'';
import { ReactQueryDevtools } from ''@tanstack/react-query-devtools''; // 调试工具

// 创建 QueryClient 实例（配置全局缓存策略）
const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 5 * 60 * 1000, // 数据 5 分钟内视为“新鲜”，不重新请求
      cacheTime: 30 * 60 * 1000, // 缓存保留 30 分钟
      refetchOnWindowFocus: true, // 窗口聚焦时刷新数据（开发环境推荐开启）
      refetchOnReconnect: true, // 网络重连时刷新数据
      retry: 1, // 请求失败后重试 1 次
      retryDelay: (attemptIndex) => {
        return attemptIndex * 1000; // 重试延迟（1s、2s、...）
      },
    },
  },
});

// 全局 Provider 组件
export const QueryProvider = ({ children }: { children: React.ReactNode }) => {
  return (
    <QueryClientProvider client={queryClient}>
      {children}
      {/* 开发环境显示调试工具（默认在右下角） */}
      {process.env.NODE_ENV === ''development'' && <ReactQueryDevtools />}
    </QueryClientProvider>
  );
};
```

在入口文件中包裹：
```tsx
// src/main.tsx
import React from ''react'';
import ReactDOM from ''react-dom/client'';
import { QueryProvider } from ''./providers/QueryProvider'';
import App from ''./App'';

const root = ReactDOM.createRoot(document.getElementById(''root'')!);
root.render(
  <QueryProvider>
    <App />
  </QueryProvider>
);
```

## 3.3 步骤 2：基础查询（useQuery）
用于获取数据（GET 请求），自动管理加载/错误/成功状态：
```tsx
import React from ''react'';
import { useQuery } from ''@tanstack/react-query'';
import { getUserList, User } from ''@/api/modules/user'';
import { Table, Spin, Alert } from ''antd'';

// 定义查询键（必须是数组，用于缓存标识）
const USER_LIST_QUERY_KEY = [''userList''];

const UserList = () => {
  // 调用接口（useQuery 接收查询键 + 异步函数）
  const { data, isLoading, isError, error, refetch } = useQuery({
    queryKey: USER_LIST_QUERY_KEY, // 缓存键（相同键复用缓存）
    queryFn: () => getUserList({ page: 1, pageSize: 10 }), // 异步请求函数
    // 额外配置（覆盖全局默认值）
    staleTime: 10 * 60 * 1000, // 10 分钟新鲜期
    enabled: true, // 是否自动触发查询（默认 true，可通过条件控制）
  });

  // 加载状态
  if (isLoading) return <Spin size="large" tip="加载中..." />;

  // 错误状态
  if (isError) return <Alert message="加载失败" description={(error as Error).message} type="error" />;

  return (
    <div>
      <Table
        dataSource={data?.list}
        columns={[
          { title: ''ID'', dataIndex: ''id'' },
          { title: ''姓名'', dataIndex: ''name'' },
          { title: ''年龄'', dataIndex: ''age'' },
        ]}
        rowKey="id"
        pagination={{ total: data?.total }}
      />
      {/* 手动刷新按钮 */}
      <button onClick={() => refetch()} style={{ marginTop: 16 }}>
        手动刷新
      </button>
    </div>
  );
};

export default UserList;
```

## 3.4 步骤 3：带参数查询（动态查询键）
查询键支持动态值（如分页参数、筛选条件），不同参数对应不同缓存：
```tsx
const UserListWithParams = () => {
  const [page, setPage] = React.useState(1);
  const pageSize = 10;

  // 动态查询键：[查询名, 分页参数, 筛选参数]
  const { data, isLoading, isError } = useQuery({
    queryKey: [''userList'', page, pageSize], // 不同 page 对应不同缓存
    queryFn: () => getUserList({ page, pageSize }),
  });

  return (
    <div>
      <Table
        dataSource={data?.list}
        columns={/* 列定义 */}
        pagination={{
          current: page,
          pageSize,
          total: data?.total,
          onChange: (newPage) => setPage(newPage), // 分页切换更新 page
        }}
      />
    </div>
  );
};
```

## 3.5 步骤 4：数据突变（useMutation）
用于修改数据（POST/PUT/DELETE 请求），支持乐观更新、缓存更新：
```tsx
import React from ''react'';
import { useMutation, useQueryClient } from ''@tanstack/react-query'';
import { addUser, getUserList } from ''@/api/modules/user'';
import { Button, Form, Input, message } from ''antd'';

const AddUserForm = () => {
  const [form] = Form.useForm();
  // 获取 QueryClient 实例（用于更新缓存）
  const queryClient = useQueryClient();

  // 定义突变（修改数据的操作）
  const addUserMutation = useMutation({
    mutationFn: (userData: { name: string; age: number }) => addUser(userData), // 异步修改函数
    // 成功回调：更新缓存 + 提示
    onSuccess: () => {
      message.success(''添加用户成功'');
      form.resetFields();
      // 方法 1：使 userList 缓存失效，触发重新请求
      queryClient.invalidateQueries({ queryKey: [''userList''] });
      // 方法 2：乐观更新（不等待接口响应，直接更新缓存）
      // queryClient.setQueryData([''userList''], (oldData) => {
      //   return {
      //     ...oldData,
      //     list: [...oldData.list, newUser],
      //     total: oldData.total + 1,
      //   };
      // });
    },
    // 失败回调
    onError: (error) => {
      message.error(`添加失败：${(error as Error).message}`);
    },
  });

  const handleSubmit = (values: { name: string; age: number }) => {
    // 触发突变
    addUserMutation.mutate(values);
  };

  return (
    <Form form={form} onFinish={handleSubmit} layout="inline">
      <Form.Item name="name" rules={[{ required: true, message: ''请输入姓名'' }]}>
        <Input placeholder="姓名" />
      </Form.Item>
      <Form.Item name="age" rules={[{ required: true, message: ''请输入年龄'' }]}>
        <Input type="number" placeholder="年龄" />
      </Form.Item>
      <Form.Item>
        <Button
          type="primary"
          htmlType="submit"
          loading={addUserMutation.isPending} // 突变加载状态
        >
          添加用户
        </Button>
      </Form.Item>
    </Form>
  );
};

export default AddUserForm;
```

## 3.6 步骤 5：无限滚动（useInfiniteQuery）
简化分页列表的无限滚动逻辑：
```tsx
import React, { useRef, useEffect } from ''react'';
import { useInfiniteQuery } from ''@tanstack/react-query'';
import { getUserList } from ''@/api/modules/user'';
import { List, Spin, message } from ''antd'';

const InfiniteUserList = () => {
  const loadMoreRef = useRef<HTMLDivElement>(null);

  // 无限查询
  const {
    data,
    isLoading,
    isError,
    fetchNextPage,
    hasNextPage,
    isFetchingNextPage,
  } = useInfiniteQuery({
    queryKey: [''infiniteUserList''],
    // queryFn 接收 pageParam（分页参数，初始为 1）
    queryFn: ({ pageParam = 1 }) => getUserList({ page: pageParam, pageSize: 10 }),
    // 提取下一页参数（判断是否还有更多数据）
    getNextPageParam: (lastPage, allPages) => {
      const totalPages = Math.ceil(lastPage.total / 10);
      const nextPage = allPages.length + 1;
      return nextPage <= totalPages ? nextPage : undefined;
    },
  });

  // 滚动监听：触底加载下一页
  useEffect(() => {
    const observer = new IntersectionObserver(
      (entries) => {
        if (entries[0].isIntersecting && hasNextPage && !isFetchingNextPage) {
          fetchNextPage(); // 加载下一页
        }
      },
      { threshold: 0.1 }
    );

    if (loadMoreRef.current) {
      observer.observe(loadMoreRef.current);
    }

    return () => {
      if (loadMoreRef.current) {
        observer.unobserve(loadMoreRef.current);
      }
    };
  }, [fetchNextPage, hasNextPage, isFetchingNextPage]);

  // 格式化数据（合并所有页的列表）
  const userList = data?.pages.flatMap((page) => page.list) || [];

  if (isLoading) return <Spin tip="加载中..." />;
  if (isError) return <div>加载失败</div>;

  return (
    <List
      dataSource={userList}
      renderItem={(user) => <List.Item>{`${user.name}（${user.age}岁）`}</List.Item>}
      loadMore={
        hasNextPage && (
          <div ref={loadMoreRef} style={{ textAlign: ''center'', padding: 16 }}>
            {isFetchingNextPage ? <Spin size="small" /> : ''加载更多''}
          </div>
        )
      }
    />
  );
};

export default InfiniteUserList;
```

# 4. SWR 实战（推荐轻量项目/Next.js）
## 4.1 环境搭建
```bash
npm install swr axios
```

## 4.2 步骤 1：全局配置（src/providers/SWRProvider.tsx）
```tsx
import React from ''react'';
import { SWRConfig } from ''swr'';
import axios from ''@/api''; // 复用已封装的 Axios 实例

// 自定义请求函数（适配 Axios）
const fetcher = async <T = any>(url: string, params?: any): Promise<T> => {
  const response = await axios.get(url, { params });
  return response;
};

export const SWRProvider = ({ children }: { children: React.ReactNode }) => {
  return (
    <SWRConfig
      value={{
        fetcher, // 全局请求函数
        revalidateOnFocus: true, // 窗口聚焦刷新
        revalidateOnReconnect: true, // 网络重连刷新
        dedupingInterval: 5 * 60 * 1000, // 5 分钟内相同请求去重
        revalidateIfStale: true, // 数据陈旧时后台刷新
      }}
    >
      {children}
    </SWRConfig>
  );
};
```

## 4.3 步骤 2：基础查询（useSWR）
```tsx
import React from ''react'';
import useSWR from ''swr'';
import { User } from ''@/api/modules/user'';
import { Table, Spin, Alert } from ''antd'';

// 查询键（字符串或数组，支持动态参数）
const USER_LIST_KEY = ''/user/list'';

const UserList = () => {
  // 带参数查询：键为数组 [url, params]
  const { data, error, isLoading, mutate } = useSWR([USER_LIST_KEY, { page: 1, pageSize: 10 }]);

  // 加载状态
  if (isLoading) return <Spin tip="加载中..." />;
  // 错误状态
  if (error) return <Alert message="加载失败" description={(error as Error).message} type="error" />;

  return (
    <div>
      <Table
        dataSource={data?.list}
        columns={[
          { title: ''ID'', dataIndex: ''id'' },
          { title: ''姓名'', dataIndex: ''name'' },
          { title: ''年龄'', dataIndex: ''age'' },
        ]}
        rowKey=...', 'f6ecfee0-71f1-4926-96ee-892bbcebe758', 'true', '2025-12-22 03:21:47.107922+00', '2025-12-23 14:22:55.069819+00'), ('62a85f30-d17a-425b-a7f3-f1eadf226b9b', 'Formik + Yup 表单方案', '# 1. Formik + Yup 核心优势
Formik 是一款成熟的 React 表单状态管理库，专注于解决表单的“脏活累活”（状态同步、验证、提交处理）；Yup 是一款声明式的 Schema 校验库，用于定义表单验证规则。两者结合可实现：
- **完整的表单状态管理**：自动处理 `values`、`errors`、`touched`、`isSubmitting` 等状态；
- **声明式验证规则**：通过 Yup Schema 定义验证规则，无需手写大量条件判断；
- **灵活的验证时机**：支持 onChange、onBlur、onSubmit 等验证时机；
- **良好的生态兼容**：支持 React Native、第三方 UI 库（Ant Design、Material UI）；
- **丰富的辅助方法**：内置表单提交、重置、字段更新等方法。

# 2. 基础安装与配置
```bash
npm install formik yup

yarn add formik yup
```

# 3. 核心概念与 API
## 3.1 Formik 组件/Hook 两种使用方式
Formik 支持两种使用方式：组件包裹式（`<Formik>` + `<Form>`）和 Hook 式（`useFormik`），推荐组件式（更简洁）。

### 方式 1：组件包裹式（基础示例）
```javascript
import { Formik, Form, Field, ErrorMessage } from ''formik'';
import * as Yup from ''yup'';

function BasicFormikForm() {
  // 1. 定义 Yup 验证 Schema
  const validationSchema = Yup.object({
    username: Yup.string()
      .required(''用户名不能为空'')
      .min(3, ''用户名长度不能少于 3 位'')
      .max(10, ''用户名长度不能超过 10 位''),
    password: Yup.string()
      .required(''密码不能为空'')
      .min(6, ''密码长度不能少于 6 位'')
  });

  return (
    <Formik
      initialValues={{ username: '''', password: '''' }} // 初始值
      validationSchema={validationSchema} // 验证规则
      onSubmit={(values, { setSubmitting }) => {
        // 提交逻辑
        setTimeout(() => {
          console.log(''表单数据：'', values);
          setSubmitting(false); // 结束提交状态
        }, 1000);
      }}
    >
      {({ isSubmitting }) => (
        <Form>
          {/* 用户名字段 */}
          <div>
            <label>用户名：</label>
            <Field name="username" type="text" placeholder="请输入用户名" />
            <ErrorMessage name="username" component="span" style={{ color: ''red'' }} />
          </div>

          {/* 密码字段 */}
          <div>
            <label>密码：</label>
            <Field name="password" type="password" placeholder="请输入密码" />
            <ErrorMessage name="password" component="span" style={{ color: ''red'' }} />
          </div>

          {/* 提交按钮（禁用提交中状态） */}
          <button type="submit" disabled={isSubmitting}>
            {isSubmitting ? ''提交中...'' : ''提交''}
          </button>
        </Form>
      )}
    </Formik>
  );
}
```

### 方式 2：Hook 式（useFormik）
```javascript
import { useFormik } from ''formik'';
import * as Yup from ''yup'';

function UseFormikForm() {
  // 初始化 Formik 实例
  const formik = useFormik({
    initialValues: { username: '''', password: '''' },
    validationSchema: Yup.object({
      username: Yup.string().required(''用户名不能为空'').min(3, ''长度≥3''),
      password: Yup.string().required(''密码不能为空'').min(6, ''长度≥6'')
    }),
    onSubmit: (values) => {
      console.log(''提交数据：'', values);
    }
  });

  return (
    <form onSubmit={formik.handleSubmit}>
      <div>
        <label>用户名：</label>
        <input
          name="username"
          type="text"
          value={formik.values.username}
          onChange={formik.handleChange}
          onBlur={formik.handleBlur}
          placeholder="请输入用户名"
        />
        {/* 显示错误（仅当字段被触碰且有错误时） */}
        {formik.touched.username && formik.errors.username && (
          <span style={{ color: ''red'' }}>{formik.errors.username}</span>
        )}
      </div>

      <div>
        <label>密码：</label>
        <input
          name="password"
          type="password"
          value={formik.values.password}
          onChange={formik.handleChange}
          onBlur={formik.handleBlur}
          placeholder="请输入密码"
        />
        {formik.touched.password && formik.errors.password && (
          <span style={{ color: ''red'' }}>{formik.errors.password}</span>
        )}
      </div>

      <button type="submit" disabled={formik.isSubmitting}>提交</button>
    </form>
  );
}
```

## 3.2 核心 API 说明
| API | 作用 |
|-----|------|
| `initialValues` | 表单初始值（对象格式，键为字段名） |
| `validationSchema` | Yup Schema 验证规则 |
| `onSubmit` | 表单提交成功回调（参数为表单值） |
| `handleSubmit` | 表单提交处理函数（绑定到 `<form>` 的 onSubmit） |
| `handleChange` | 字段变化处理函数（绑定到 input 的 onChange） |
| `handleBlur` | 字段失焦处理函数（绑定到 input 的 onBlur） |
| `values` | 当前表单值（对象） |
| `errors` | 当前表单错误信息（对象） |
| `touched` | 字段是否被触碰（对象，键为字段名，值为布尔值） |
| `isSubmitting` | 表单是否正在提交（布尔值） |
| `resetForm` | 重置表单到初始值（可传入新初始值） |

# 4. Yup Schema 核心语法
Yup 提供了丰富的 Schema 类型和验证方法，支持字符串、数字、布尔值、数组、对象等类型的验证：

## 4.1 基础类型验证
```javascript
import * as Yup from ''yup'';

// 字符串验证
Yup.string()
  .required(''必填'')
  .min(3, ''最小长度3'')
  .max(10, ''最大长度10'')
  .email(''邮箱格式错误'')
  .matches(/^1[3-9]\d{9}$/, ''手机号格式错误'')
  .oneOf([''男'', ''女''], ''只能选择男/女'');

// 数字验证
Yup.number()
  .required(''必填'')
  .min(18, ''最小值18'')
  .max(60, ''最大值60'')
  .integer(''必须为整数'');

// 布尔值验证
Yup.boolean()
  .required(''必填'')
  .oneOf([true], ''必须同意协议'');
```

## 4.2 嵌套对象验证
```javascript
const validationSchema = Yup.object({
  user: Yup.object({
    name: Yup.string().required(''姓名不能为空''),
    email: Yup.string().email(''邮箱格式错误'').required(''邮箱不能为空'')
  }).required(''用户信息不能为空''),
  address: Yup.object({
    city: Yup.string().required(''城市不能为空''),
    street: Yup.string().required(''街道不能为空'')
  })
});
```

## 4.3 数组验证
```javascript
const validationSchema = Yup.object({
  hobbies: Yup.array()
    .min(1, ''至少选择一个兴趣'')
    .of(Yup.string().oneOf([''sports'', ''reading'', ''coding''], ''无效的兴趣选项''))
});
```

## 4.4 条件验证（when）
根据其他字段的值动态调整验证规则：
```javascript
const validationSchema = Yup.object({
  isStudent: Yup.boolean(),
  studentId: Yup.string()
    .when(''isStudent'', {
      is: true, // 当 isStudent 为 true 时
      then: (schema) => schema.required(''学生ID不能为空'') // 必须填写学生ID
    })
});
```

# 5. 高级用法
## 5.1 自定义验证（test）
Yup 支持通过 `test` 方法自定义验证逻辑（同步/异步）：
```javascript
const validationSchema = Yup.object({
  password: Yup.string()
    .required(''密码不能为空'')
    .min(6, ''密码长度≥6''),
  confirmPassword: Yup.string()
    .required(''确认密码不能为空'')
    .test(''password-match'', ''两次密码不一致'', function (value) {
      // 通过 this.parent 获取其他字段值
      return value === this.parent.password;
    })
});
```

## 5.2 异步验证
```javascript
const validationSchema = Yup.object({
  email: Yup.string()
    .email(''邮箱格式错误'')
    .required(''邮箱不能为空'')
    .test(''email-unique'', ''该邮箱已被注册'', async (value) => {
      const res = await fetch(`/api/check-email?email=${value}`);
      const data = await res.json();
      return data.available;
    })
});
```

## 5.3 与 UI 库集成（以 Ant Design 为例）
```javascript
import { Formik, Form } from ''formik'';
import * as Yup from ''yup'';
import { Input, Button, Form, message } from ''antd'';

function AntdFormikForm() {
  const validationSchema = Yup.object({
    username: Yup.string().required(''用户名不能为空''),
    password: Yup.string().required(''密码不能为空'').min(6, ''密码长度≥6'')
  });

  return (
    <Formik
      initialValues={{ username: '''', password: '''' }}
      validationSchema={validationSchema}
      onSubmit={(values) => {
        message.success(''提交成功'');
        console.log(values);
      }}
    >
      {({ values, errors, touched, handleChange, handleBlur, isSubmitting }) => (
        <Form layout="vertical">
          <Form.Item
            label="用户名"
            validateStatus={touched.username && errors.username ? ''error'' : ''''}
            help={touched.username && errors.username ? errors.username : ''''}
          >
            <Input
              name="username"
              value={values.username}
              onChange={handleChange}
              onBlur={handleBlur}
              placeholder="请输入用户名"
            />
          </Form.Item>

          <Form.Item
            label="密码"
            validateStatus={touched.password && errors.password ? ''error'' : ''''}
            help={touched.password && errors.password ? errors.password : ''''}
          >
            <Input.Password
              name="password"
              value={values.password}
              onChange={handleChange}
              onBlur={handleBlur}
              placeholder="请输入密码"
            />
          </Form.Item>

          <Form.Item>
            <Button type="primary" htmlType="submit" loading={isSubmitting}>
              提交
            </Button>
          </Form.Item>
        </Form>
      )}
    </Formik>
  );
}
```

## 5.4 表单重置与setFieldValue
- `resetForm`：重置表单到初始值；
- `setFieldValue`：手动设置单个字段值；
- `setFieldTouched`：手动标记字段为已触碰。

```javascript
<Formik
  initialValues={{ username: '''' }}
  onSubmit={(values, { resetForm }) => {
    console.log(values);
    resetForm(); // 重置表单
  }}
>
  {({ setFieldValue, setFieldTouched }) => (
    <Form>
      <Field name="username" />
      <button type="button" onClick={() => setFieldValue(''username'', ''默认值'')}>
        设置默认值
      </button>
      <button type="button" onClick={() => setFieldTouched(''username'', true)}>
        标记为已触碰
      </button>
      <button type="submit">提交</button>
    </Form>
  )}
</Formik>
```

# 6. Formik vs React Hook Form 对比
| 特性 | Formik | React Hook Form |
|------|--------|-----------------|
| 设计理念 | 受控表单 + 完整状态管理 | 非受控表单 + 原生验证 |
| 体积 | 约 18KB（gzip） | 约 10KB（gzip） |
| 性能 | 中等（受控表单可能频繁重渲染） | 优秀（仅追踪必要字段） |
| 验证方式 | Yup Schema（推荐）/自定义 | 内置规则/自定义/Yup（支持） |
| 学习成本 | 中等（API 较多） | 低（API 简洁） |
| 生态兼容 | 良好 | 良好 |
| 适用场景 | 复杂表单、需要完整状态管理 | 高性能需求、简单/中等表单 |

# 7. 最佳实践
1. **Schema 复用**：将通用验证规则（如手机号、邮箱）封装为独立的 Yup Schema，便于复用；
2. **错误提示优化**：仅在字段被触碰（`touched`）后显示错误，避免初始加载时的错误提示；
3. **提交状态管理**：使用 `isSubmitting` 禁用提交按钮，防止重复提交；
4. **异步验证防抖**：异步验证（如邮箱查重）添加防抖，减少请求次数；
5. **表单嵌套处理**：使用嵌套字段名（如 `user.name`）管理复杂表单结构；
6. **与 UI 库集成**：优先使用组件库的表单验证状态（如 Ant Design 的 `validateStatus`），保持样式统一。
...', 'fa2521c5-ab87-4500-9375-449364eb3b13', 'true', '2025-12-22 03:19:12.977666+00', '2025-12-23 13:13:20.764677+00'), ('63448a81-60f8-4335-a5db-dc369065e7ba', 'Zustand/Redux DevTools 状态调试', '# 1. 状态调试工具核心价值
复杂 React 项目中，全局状态（如用户信息、商品列表）的变化难以追踪，状态调试工具可实现：
- 可视化状态变化历史：记录每一次状态修改的时间、原因、前后数据；
- 时间旅行调试：回滚到任意历史状态，复现问题场景；
- 状态变更追踪：定位触发状态修改的组件/动作；
- 性能分析：识别频繁的状态更新导致的性能问题。

# 2. Redux DevTools 调试
## 2.1 安装与配置
### 2.1.1  浏览器扩展安装
Chrome/Firefox 应用商店搜索「Redux DevTools」安装扩展。

### 2.1.2 项目集成（Redux Toolkit 推荐）
Redux Toolkit 内置支持 Redux DevTools，无需额外配置：
```typescript
// src/store/index.ts
import { configureStore } from ''@reduxjs/toolkit'';
import userReducer from ''./slices/userSlice'';

export const store = configureStore({
  reducer: {
    user: userReducer,
  },
  // Redux Toolkit 自动配置 DevTools，生产环境自动禁用
  devTools: process.env.NODE_ENV !== ''production'',
});

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;
```

### 2.1.3 传统 Redux 集成（非 Toolkit）
```typescript
import { createStore, applyMiddleware, compose } from ''redux'';
import rootReducer from ''./reducers'';

// 集成 DevTools
const composeEnhancers = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose;
const store = createStore(rootReducer, composeEnhancers(applyMiddleware(/* 中间件 */)));

export default store;
```

## 2.2 核心功能与调试技巧
### 2.2.1 状态监控（State 面板）
- 左侧展示 Redux store 的完整状态树，支持展开/折叠对象；
- 右侧展示选中状态的详细数据，支持搜索、复制；
- 实时更新：每次 dispatch action 后，状态面板自动刷新。

### 2.2.2 动作追踪（Actions 面板）
- 记录所有 dispatch 的 action，包括：
  - **Action Type**：动作类型（如 `user/loginSuccess`）；
  - **Payload**：动作携带的数据；
  - **Timestamp**：触发时间；
  - **Duration**：状态更新耗时；
- 筛选功能：按 action type 过滤，快速定位目标动作。

### 2.2.3 时间旅行调试
- 点击历史动作列表中的任意一项，Redux store 会回滚到该动作执行后的状态；
- 「Pause」按钮：暂停状态更新，复现连续动作导致的问题；
- 「Replay」按钮：重新执行选中的动作，验证状态更新逻辑。

### 2.2.4 状态差异对比（Diff 面板）
- 选择任意两个历史状态，Diff 面板展示数据差异（新增/修改/删除的字段）；
- 示例：对比登录前后的 `user` 状态，确认用户信息是否正确存储。

### 2.2.5  性能分析（Performance 面板）
- 录制动作执行过程，分析每个 action 触发的状态更新耗时；
- 识别频繁 dispatch 的 action（如输入框实时搜索导致的高频 action），可通过防抖优化。

### 2.2.6 高级配置
- 「Settings」面板配置：
  - 黑/白名单：指定需要/不需要监控的 action type；
  - 持久化状态：刷新页面后保留状态历史；
  - 状态序列化：处理不可序列化数据（如函数、Symbol）。

## 2.3 常见问题解决
### 2.3.1 DevTools 不显示状态
- 确认 store 配置了 `devTools: true`；
- 检查是否安装了多个 Redux DevTools 扩展（冲突导致失效）；
- 确保 action 是标准格式（包含 `type` 字段）。

### 2.3.2 时间旅行后状态异常
- 检查 reducer 是否为纯函数（纯函数是时间旅行的前提）；
- 避免在 reducer 中修改原始状态（必须返回新对象/数组）。

### 2.3.3 状态无法序列化
- 避免在 state 中存储不可序列化数据（如 DOM 节点、函数）；
- 如需存储，在 DevTools 配置中添加序列化规则：
  ```typescript
  const store = configureStore({
    reducer: { user: userReducer },
    devTools: {
      serialize: {
        replacer: (key, value) => {
          // 处理不可序列化数据
          if (key === ''functionData'') return ''[Function]'';
          return value;
        },
      },
    },
  });
  ```

# 3. Zustand DevTools 调试
## 3.1 安装与配置
Zustand 轻量级状态管理库，需手动集成 Redux DevTools：
```bash
npm install zustand redux-devtools-extension # 安装依赖
```

```typescript
// src/store/useUserStore.ts
import { create } from ''zustand'';
import { devtools, persist } from ''zustand/middleware'';

interface UserState {
  name: string;
  age: number;
  setName: (name: string) => void;
  setAge: (age: number) => void;
}

export const useUserStore = create<UserState>()(
  devtools(
    persist(
      (set) => ({
        name: ''张三'',
        age: 18,
        setName: (name) => set({ name }, false, ''user/setName''), // 第三个参数为 action type
        setAge: (age) => set({ age }, false, ''user/setAge''),
      }),
      { name: ''user-storage'' } // 持久化配置
    ),
    { name: ''userStore'' } // DevTools 实例名
  )
);
```

## 3.2 核心调试技巧
### 3.2.1 状态监控与动作追踪
- 打开 Redux DevTools 扩展，选择「userStore」实例；
- 面板中展示 Zustand store 的状态变化，action type 对应 `set` 方法的第三个参数（如 `user/setName`）；
- 支持时间旅行调试：回滚到任意历史状态，验证状态修改逻辑。

### 3.2.2 中间件调试
- 结合 `devtools` 中间件的 `name` 参数，区分多个 Zustand store（如 `userStore`/`cartStore`）；
- 动作描述：`set` 方法的第三个参数建议遵循「模块/动作」命名规范（如 `cart/addItem`），便于识别。

### 3.2.3 持久化状态调试
- 「State」面板中查看 `persist` 中间件存储的状态（如 localStorage 中的数据）；
- 验证持久化逻辑：刷新页面后，状态是否从 localStorage 恢复。

## 3.3 高级调试配置
### 3.3.1 禁用 DevTools（生产环境）
```typescript
const useUserStore = create<UserState>()(
  (process.env.NODE_ENV === ''development'' ? devtools : (f) => f)(
    persist((set) => ({ /* 状态定义 */ }))
  )
);
```

### 3.3.2 状态变更日志
```typescript
devtools(
  (set) => ({ /* 状态定义 */ }),
  {
    name: ''userStore'',
    enabled: process.env.NODE_ENV === ''development'',
    actionsBlacklist: [''user/setAge''], // 忽略指定动作
  }
)
```

# 4. 状态调试最佳实践
1. 统一 action type 命名规范（如「模块/动作」），便于筛选和识别；
2. 生产环境禁用 DevTools，避免性能损耗和安全风险；
3. 结合 React DevTools，定位触发状态更新的组件；
4. 对频繁更新的状态（如输入框内容），添加防抖/节流，减少状态变更次数；
5. 定期清理状态历史（DevTools 「Clear」按钮），避免内存占用过高。', 'ac88594f-879e-410b-94ce-266d80cce0f4', 'true', '2025-12-22 03:22:07.008515+00', '2025-12-23 14:30:39.111329+00'), ('66dfc593-871b-47c6-b541-f63c9de6a5b6', 'Zustand 核心特性', '在上一节入门基础上，本文将深入 Zustand 的核心特性，包括状态更新的高级用法、中间件的使用（如调试、日志）、状态持久化（本地存储）等，帮助你灵活应对复杂业务场景。

# 1. 状态更新的高级用法
Zustand 的 `set` 函数支持多种灵活的状态更新方式，除了基础的“函数式更新”“直接更新”，还支持“状态合并”“替换状态”“异步更新”等场景。

## 1.1 状态合并（默认行为）
`set` 函数默认会将新状态与旧状态合并，无需手动传递所有字段：
```jsx
const useUserStore = create((set) => ({
  name: ''张三'',
  age: 20,
  address: ''北京'',
  // 仅更新 name，age 和 address 保持不变
  updateName: (newName) => set({ name: newName }),
}));
```

## 1.2 替换状态（覆盖整个状态）
若需完全替换 Store 中的所有状态（而非合并），可给 `set` 函数传递第二个参数 `replace: true`：
```jsx
const useUserStore = create((set) => ({
  name: ''张三'',
  age: 20,
  // 替换整个状态（仅保留新传递的字段）
  replaceUser: (newUser) => set(newUser, true),
}));

// 调用后，Store 状态变为 { name: ''李四'', age: 25 }（address 被删除）
useUserStore.getState().replaceUser({ name: ''李四'', age: 25 });
```

## 1.3 异步状态更新
Zustand 支持直接在状态方法中写异步逻辑（无需额外中间件），通过 `set` 函数在异步操作完成后更新状态：
```jsx
const useUserStore = create((set) => ({
  userInfo: null,
  loading: false,
  error: null,

  // 异步获取用户信息
  fetchUser: async (userId) => {
    set({ loading: true, error: null }); // 开始请求：更新加载状态
    try {
      const res = await fetch(`https://api.example.com/users/${userId}`);
      const data = await res.json();
      set({ userInfo: data, loading: false }); // 请求成功：更新用户信息
    } catch (err) {
      set({ error: err.message, loading: false }); // 请求失败：更新错误信息
    }
  },
}));

// 组件中调用异步方法
const fetchUser = useUserStore((state) => state.fetchUser);
useEffect(() => {
  fetchUser(1); // 组件挂载时请求用户 ID=1 的信息
}, [fetchUser]);
```

## 1.4 基于当前状态的链式更新
若需连续修改状态（且后一次修改依赖前一次的结果），可链式调用 `set` 函数（或在一个 `set` 中处理）：
```jsx
const useCounterStore = create((set) => ({
  count: 0,
  // 链式更新：先 +1，再 *2（最终 count = (0+1)*2 = 2）
  incrementAndDouble: () => 
    set((state) => ({ count: state.count + 1 }))
      .then(() => set((state) => ({ count: state.count * 2 }))),
}));
```

# 2. 中间件（Middleware）
中间件是 Zustand 扩展功能的核心机制，用于拦截 Store 的创建、状态更新、方法调用等过程，实现日志打印、调试、持久化等功能。Zustand 内置了多个常用中间件，也支持自定义中间件。

## 2.1 核心中间件介绍
Zustand 的中间件通过 `compose` 函数组合（需从 `zustand/middleware` 导入），常用中间件如下：

### （1）`devtools`：Redux DevTools 调试
支持在 Redux DevTools 中查看状态变化历史、Dispatch 记录、时间线等，开发阶段必备：
```jsx
import { create } from ''zustand'';
import { devtools } from ''zustand/middleware''; // 导入调试中间件

// 创建 Store 时包裹 devtools 中间件
const useCounterStore = create(
  devtools((set) => ({
    count: 0,
    increment: () => set((state) => ({ count: state.count + 1 })),
  }), {
    name: ''counter-store'', // 调试工具中显示的 Store 名称（可选）
  })
);
```

### （2）`logger`：控制台日志打印
在控制台打印状态更新的详细日志（旧状态、新状态、触发方法等），简单调试场景可用：
```jsx
import { create } from ''zustand'';
import { logger } from ''zustand/middleware''; // 导入日志中间件

// 组合 logger 和 devtools 中间件（顺序不影响，compose 会自动处理）
const useCounterStore = create(
  logger(
    devtools((set) => ({
      count: 0,
      increment: () => set((state) => ({ count: state.count + 1 })),
    }))
  )
);
```

### （3）`persist`：状态持久化（本地存储）
将 Store 状态持久化到 `localStorage` 或 `sessionStorage`，页面刷新后状态不丢失，核心中间件之一：
```jsx
import { create } from ''zustand'';
import { persist } from ''zustand/middleware''; // 导入持久化中间件

const useUserStore = create(
  persist(
    (set) => ({
      userInfo: null,
      token: '''',
      login: (token, user) => set({ token, userInfo: user }),
      logout: () => set({ token: '''', userInfo: null }),
    }),
    {
      name: ''user-storage'', // 本地存储的 key（默认在 localStorage 中）
      getStorage: () => sessionStorage, // 可选：指定存储方式（sessionStorage）
      partialize: (state) => ({ token: state.token }), // 可选：仅持久化部分状态（如只存 token）
    }
  )
);
```

### 持久化中间件关键配置
- `name`：本地存储的键名（如 `user-storage`，对应 `localStorage.getItem(''user-storage'')`）；
- `getStorage`：指定存储介质，默认 `localStorage`，可改为 `sessionStorage` 或自定义存储（如 IndexedDB）；
- `partialize`：过滤需要持久化的状态（返回需要持久化的对象，忽略其他字段）；
- `onRehydrateStorage`：持久化恢复前的回调（如处理状态格式兼容）；
- `version`：状态版本号（用于版本迁移，避免旧版本状态导致的问题）。

## 2.2 中间件组合（compose）
当需要同时使用多个中间件时，可使用 `compose` 函数（从 `zustand/middleware` 导入）统一组合：
```jsx
import { create } from ''zustand'';
import { devtools, logger, persist, compose } from ''zustand/middleware'';

// 组合多个中间件（顺序：从右到左执行，即 persist → logger → devtools）
const middleware = compose(persist, logger, devtools);

const useCounterStore = create(
  middleware((set) => ({
    count: 0,
    increment: () => set((state) => ({ count: state.count + 1 })),
  }), {
    // persist 配置（中间件的配置需放在第二个参数）
    name: ''counter-storage'',
    // devtools 配置
    devtools: { name: ''counter-store'' },
  })
);
```

## 2.3 自定义中间件（进阶）
若内置中间件无法满足需求，可自定义中间件。自定义中间件是一个函数，接收 `fn`（Store 初始化函数）和 `options`（配置），返回新的初始化函数：
```jsx
// 自定义中间件：记录状态更新的时间戳
const timestampMiddleware = (fn) => (set, get, store) => {
  // 重写 set 函数，添加时间戳
  const newSet = (...args) => {
    // 调用原始 set 函数更新状态
    set(...args);
    // 记录更新时间戳
    console.log(`状态更新时间：${new Date().toLocaleTimeString()}`);
  };
  // 传递新的 set 函数给原始 Store
  return fn(newSet, get, store);
};

// 使用自定义中间件
const useCounterStore = create(
  timestampMiddleware((set) => ({
    count: 0,
    increment: () => set((state) => ({ count: state.count + 1 })),
  }))
);
```

# 3. 其他核心特性
## 3.1 订阅状态变化
除了通过 `useStore` 在组件中自动订阅状态，还可通过 `subscribe` 方法手动订阅状态变化（适用于非 React 环境或全局监听）：
```jsx
const useCounterStore = create((set) => ({ count: 0, increment: () => set((s) => ({ count: s.count + 1 })) }));

// 手动订阅 count 变化
const unsubscribe = useCounterStore.subscribe(
  (state) => state.count, // 订阅的状态
  (newCount, oldCount) => { // 状态变化时的回调
    console.log(`count 从 ${oldCount} 变为 ${newCount}`);
  }
);

// 取消订阅（如组件卸载时）
unsubscribe();
```

## 3.2 获取当前状态（非组件环境）
通过 `getState` 方法可在非组件环境（如工具函数、异步回调）中获取当前 Store 状态：
```jsx
// 工具函数中获取状态
const getCurrentCount = () => {
  return useCounterStore.getState().count;
};

// 异步回调中获取状态
fetch(''/api/data'').then(() => {
  const count = useCounterStore.getState().count;
  console.log(''当前计数：'', count);
});
```

## 3.3 销毁 Store（可选）
若需手动销毁 Store（如单页应用路由切换时清理状态），可调用 `destroy` 方法：
```jsx
useCounterStore.destroy();
```

# 4. 核心特性使用注意事项
1. **异步状态更新的错误处理**：异步方法中必须捕获错误，避免未处理的 Promise 错误导致应用崩溃；
2. **持久化状态的兼容性**：持久化的状态需支持 JSON 序列化（如函数、Symbol 等类型无法持久化，会被自动忽略）；
3. **中间件顺序**：组合多个中间件时，顺序会影响执行逻辑（如 `persist` 应放在最外层，确保状态更新先被持久化）；
4. **手动订阅的清理**：手动调用 `subscribe` 后，需在适当时候（如组件卸载）调用 `unsubscribe`，避免内存泄漏；
5. **状态不可变性**：虽然 Zustand 自动处理状态合并，但仍需避免直接修改状态（如 `state.count += 1`），必须通过 `set` 函数更新。', 'ed2cdaf2-c966-4d9f-bfad-740b9f352c61', 'true', '2025-12-22 03:10:34.735536+00', '2025-12-23 03:13:29.755702+00'), ('69b5e14c-c992-460d-8a39-ba63c8c50674', '嵌套路由', '在实际 React 项目开发中，页面结构往往不是扁平的——比如一个后台管理系统，顶部有导航栏、左侧有侧边栏，点击侧边栏不同选项时，仅右侧内容区域发生变化。这种“外层布局固定，内层内容动态切换”的场景，正是**嵌套路由**要解决的核心问题。

# 1. 嵌套路由的核心概念
嵌套路由指的是路由之间存在层级关系：一个父路由对应一个包含公共布局的组件，子路由对应布局内的具体内容组件。React Router 中实现嵌套路由的关键是：
1. 父路由的 `path` 作为基础路径，子路由的 `path` 拼接在其后（支持相对路径）；
2. 父组件中通过 `<Outlet />` 组件标记子路由内容的渲染位置。

# 2. 基本使用步骤
## 2.1 定义嵌套路由规则
在 `Routes` 中，给父路由的 `children` 属性配置子路由列表：
```jsx
import { BrowserRouter, Routes, Route } from ''react-router-dom'';
import Layout from ''./pages/Layout''; // 父布局组件
import Home from ''./pages/Home'';     // 子组件1
import UserList from ''./pages/UserList''; // 子组件2
import UserDetail from ''./pages/UserDetail''; // 子组件3（带动态参数）

function App() {
  return (
    <BrowserRouter>
      <Routes>
        {/* 父路由：path 为基础路径，element 为布局组件 */}
        <Route path="/" element={<Layout />}>
          {/* 子路由：path 为相对路径（可省略 /），index 表示默认子路由 */}
          <Route index element={<Home />} />
          <Route path="users" element={<UserList />} />
          <Route path="users/:id" element={<UserDetail />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}
```

## 2.2 父布局组件中使用 `<Outlet />`
`<Outlet />` 是 React Router 提供的“占位组件”，用于渲染当前匹配的子路由组件：
```jsx
// pages/Layout.jsx
import { Outlet, Link } from ''react-router-dom'';

export default function Layout() {
  return (
    <div className="app-layout">
      {/* 公共侧边栏（固定布局） */}
      <aside>
        <Link to="/">首页</Link>
        <Link to="/users">用户列表</Link>
      </aside>
      {/* 子路由内容渲染位置 */}
      <main>
        <Outlet />
      </main>
    </div>
  );
}
```

## 2.3 子路由组件正常编写
子组件无需关心嵌套关系，只需专注自身功能：
```jsx
// pages/UserList.jsx
export default function UserList() {
  return <div>用户列表页面：张三、李四、王五</div>;
}
```

# 3. 关键细节
1. **默认子路由（index）**：当父路由匹配但没有具体子路由匹配时（如访问 `/`），渲染 `index` 对应的子组件，避免 `<Outlet />` 区域空白。
2. **相对路径与绝对路径**：子路由的 `path` 若以 `/` 开头为绝对路径，否则为相对父路由的路径（推荐使用相对路径，便于路由复用）。
3. **嵌套多层路由**：支持无限层级嵌套，只需在子路由中继续配置 `children` 并使用 `<Outlet />`。
4. **子路由的导航**：子路由间跳转可使用相对路径（如在 `UserList` 中跳转到 `users/1`，可写 `<Link to="1">`）。

# 4. 嵌套路由的优势
- 复用公共布局（如导航栏、侧边栏、页脚），减少代码冗余；
- 清晰的路由层级结构，与页面结构一一对应，便于维护；
- 支持局部内容刷新，无需重新渲染整个页面，提升用户体验。', '77b830a2-38dc-41a0-8e20-9f29ffc5a332', 'true', '2025-12-22 02:07:51.974472+00', '2025-12-23 02:50:27.210642+00'), ('6dd0f2b6-3b01-4fc1-8487-45ae34eaa3ae', '子传父——回调函数', 'React 是单向数据流，数据只能从父组件流向子组件，无法直接反向传递。但实际开发中，子组件常需向父组件传递数据（如表单输入、按钮点击事件结果），此时需通过**回调函数传参**实现“子传父”，核心思路是：父组件传递一个回调函数给子组件，子组件调用该函数并传入需要传递的数据。

# 1. 回调函数传参核心流程
## 1.1 父组件：定义回调函数 + 传递给子组件
父组件先定义一个接收参数的回调函数（用于处理子组件传递的数据），再将该函数作为 props 传递给子组件。
```jsx
// 父组件 Parent.jsx
import Child from ''./Child'';
import { useState } from ''react'';

function Parent() {
  const [childMsg, setChildMsg] = useState(''''); // 存储子组件传递的数据

  // 1. 定义回调函数：接收子组件传递的参数
  const handleChildData = (data, type) => {
    console.log(''子组件传递的数据：'', data);
    setChildMsg(`[${type}] ${data}`); // 处理数据（如更新父组件状态）
  };

  return (
    <div>
      <h1>父组件</h1>
      <p>子组件传递的信息：{childMsg}</p>
      {/* 2. 将回调函数作为 props 传递给子组件 */}
      <Child onSendData={handleChildData} />
    </div>
  );
}
```

## 1.2 子组件：调用回调函数 + 传入数据
子组件通过 `props` 接收父组件传递的回调函数，在需要传递数据的时机（如按钮点击、表单输入变化、接口请求成功后）调用该函数，并将数据作为参数传入。
```jsx
// 子组件 Child.jsx（函数组件）
function Child(props) {
  const [inputValue, setInputValue] = useState('''');

  // 子组件内部事件：触发数据传递
  const handleClick = () => {
    // 3. 调用父组件传递的回调函数，传入需要传递的数据（可传多个参数）
    props.onSendData(inputValue, ''输入内容'');
  };

  return (
    <div>
      <h2>子组件</h2>
      <input
        type="text"
        value={inputValue}
        onChange={(e) => setInputValue(e.target.value)}
        placeholder="请输入要传递给父组件的内容"
      />
      <button onClick={handleClick}>发送给父组件</button>
    </div>
  );
}

// 子组件 Child.jsx（类组件）
import React from ''react'';
class Child extends React.Component {
  state = { inputValue: '''' };

  handleInputChange = (e) => {
    this.setState({ inputValue: e.target.value });
  };

  handleClick = () => {
    // 类组件通过 this.props 调用回调函数
    this.props.onSendData(this.state.inputValue, ''输入内容'');
  };

  render() {
    return (
      <div>
        <input
          type="text"
          value={this.state.inputValue}
          onChange={this.handleInputChange}
        />
        <button onClick={this.handleClick}>发送给父组件</button>
      </div>
    );
  }
}
```

# 2. 常见使用场景
## 2.1 表单数据传递
子组件是表单组件（如输入框、选择器），将用户输入的内容传递给父组件存储或提交：
```jsx
// 子组件：表单组件
function FormChild(props) {
  const handleSubmit = (e) => {
    e.preventDefault();
    const formData = {
      username: e.target.username.value,
      password: e.target.password.value
    };
    props.onFormSubmit(formData); // 传递表单数据给父组件
  };

  return (
    <form onSubmit={handleSubmit}>
      <input name="username" placeholder="用户名" />
      <input name="password" type="password" placeholder="密码" />
      <button type="submit">提交</button>
    </form>
  );
}

// 父组件：接收表单数据并处理
function Parent() {
  const handleSubmit = (formData) => {
    console.log(''表单提交数据：'', formData);
    // 执行接口请求等逻辑
  };
  return <FormChild onFormSubmit={handleSubmit} />;
}
```

## 2.2 事件结果传递
子组件的事件（如按钮点击、弹窗关闭）结果传递给父组件，用于更新父组件状态：
```jsx
// 子组件：弹窗组件
function ModalChild(props) {
  const handleClose = () => {
    props.onClose(false); // 传递“关闭”状态给父组件
  };
  const handleConfirm = () => {
    props.onClose(true); // 传递“确认”状态给父组件
  };

  return (
    <div className="modal">
      <p>是否确认删除？</p>
      <button onClick={handleClose}>取消</button>
      <button onClick={handleConfirm}>确认</button>
    </div>
  );
}

// 父组件：控制弹窗显示/隐藏
function Parent() {
  const [isModalOpen, setIsModalOpen] = useState(true);

  const handleModalClose = (isConfirmed) => {
    setIsModalOpen(false);
    if (isConfirmed) {
      console.log(''用户确认删除，执行删除逻辑'');
    }
  };

  return isModalOpen ? <ModalChild onClose={handleModalClose} /> : null;
}
```

## 2.3 异步数据传递
子组件内部发起接口请求，请求成功后将结果传递给父组件：
```jsx
// 子组件：数据请求组件
function DataChild(props) {
  const fetchData = async () => {
    const res = await fetch(''/api/user'');
    const data = await res.json();
    props.onDataFetched(data); // 传递异步请求结果给父组件
  };

  useEffect(() => {
    fetchData();
  }, []);

  return <div>正在请求数据...</div>;
}

// 父组件：接收并展示数据
function Parent() {
  const [userData, setUserData] = useState(null);
  const handleData = (data) => {
    setUserData(data);
  };
  return <DataChild onDataFetched={handleData} />;
}
```

# 3. 注意事项
## 3.1 避免回调函数重复创建（性能优化）
父组件每次渲染时，若直接定义匿名函数传递给子组件，会导致子组件认为 `props` 变化而重复渲染（尤其是类组件或未使用 `React.memo` 的函数组件）。优化方案：
- 函数组件：使用 `useCallback` 缓存回调函数。
- 类组件：将回调函数定义为类的实例方法（箭头函数形式）。

```jsx
// 函数组件优化：useCallback 缓存回调
import { useCallback } from ''react'';

function Parent() {
  const [childMsg, setChildMsg] = useState('''');

  // 用 useCallback 缓存，依赖项为 setChildMsg（稳定函数）
  const handleChildData = useCallback((data) => {
    setChildMsg(data);
  }, [setChildMsg]);

  return <Child onSendData={handleChildData} />;
}

// 类组件优化：箭头函数实例方法（this 绑定稳定）
class Parent extends React.Component {
  state = { childMsg: '''' };

  // 箭头函数自动绑定 this，且每次渲染不会重新创建
  handleChildData = (data) => {
    this.setState({ childMsg: data });
  };

  render() {
    return <Child onSendData={this.handleChildData} />;
  }
}
```

## 3.2 回调函数的参数传递
回调函数支持传递多个参数，子组件可根据需求传递任意数据，父组件按顺序接收即可：
```jsx
// 子组件：传递多个参数
props.onSendData(inputValue, ''输入类型'', new Date().getTime());

// 父组件：按顺序接收多个参数
const handleChildData = (content, type, timestamp) => {
  console.log(''内容：'', content, ''类型：'', type, ''时间戳：'', timestamp);
};
```

## 3.3 避免循环调用
确保回调函数只在特定事件触发时调用（如点击、输入变化），不要直接在组件渲染时调用，否则会导致无限循环：
```jsx
// 错误：直接调用回调函数，导致组件渲染时无限执行
<Child onSendData={handleChildData(''错误示例'')} />

// 正确：传递函数引用，由子组件在事件中调用
<Child onSendData={handleChildData} />
```

# 4. 核心总结
1. **核心原理**：父组件传递回调函数给子组件，子组件调用该函数并传入数据，间接实现“子传父”。
2. **使用步骤**：父组件定义回调 → 传递给子组件 → 子组件触发事件时调用回调并传参。
3. **性能优化**：函数组件用 `useCallback` 缓存回调，类组件用箭头函数实例方法。
4. **适用场景**：表单数据传递、事件结果反馈、异步数据回调等需要子组件向父组件传递信息的场景。', '803ada09-ee46-463c-b7f3-403560bfc20b', 'true', '2025-12-19 10:50:24.127903+00', '2025-12-19 10:50:24.127903+00'), ('6eb94efd-6f95-44a6-af65-f9388db5463f', '自定义 Hooks 设计规范', '自定义 Hooks 是 React 中复用组件逻辑的核心方案，本质是封装了可复用的 Hooks 调用逻辑的函数，遵循特定规范才能保证可读性、复用性和兼容性。以下是自定义 Hooks 的核心设计规范：

# 1. 命名规范
1. **必须以 `use` 开头**
   这是 React 识别自定义 Hooks 的关键标识，既符合 React 官方约定，也能让开发者一眼识别这是 Hooks 函数（而非普通工具函数）。
   - ✅ 正确示例：`useRequest`、`useLocalStorage`、`useDebounce`
   - ❌ 错误示例：`requestData`、`localStorageHelper`、`debounceHandler`

2. **名称体现功能语义**
   命名需清晰描述 Hooks 的核心作用，避免模糊或缩写（除非是行业通用缩写，如 `debounce`）。
   - ✅ 语义明确：`useScrollPosition`（监听滚动位置）、`useWindowSize`（监听窗口尺寸）
   - ❌ 语义模糊：`useData`、`useUtil`、`useFn`

# 2. 复用逻辑设计规范
## 2.1 单一职责原则
一个自定义 Hooks 只专注于解决一个核心问题，避免封装过多无关逻辑，保证复用性和可维护性。
- ✅ 示例：`useDebounce` 仅处理防抖逻辑，`useThrottle` 仅处理节流逻辑，而非将防抖+节流+请求封装在一个 Hooks 中。
- ❌ 反例：`useCommon`（同时封装请求、防抖、本地存储逻辑），既难复用，也难调试。

## 2.2 依赖透明化
自定义 Hooks 内部使用的 `useEffect`、`useCallback` 等 Hooks 的依赖项，若需要外部传入，需通过参数显式声明，避免隐式依赖导致的 bug。
```jsx
// ✅ 依赖透明：将防抖延迟时间作为参数传入，外部可控制
function useDebounce(value, delay) {
  const [debouncedValue, setDebouncedValue] = useState(value);
  useEffect(() => {
    const timer = setTimeout(() => setDebouncedValue(value), delay);
    return () => clearTimeout(timer);
  }, [value, delay]); // 依赖项包含外部传入的 delay
  return debouncedValue;
}
```

## 2.3 返回值灵活适配场景
根据 Hooks 功能设计合理的返回值：
- 单一功能返回单一值：如 `useDebounce` 返回防抖后的值；
- 复杂功能返回对象/数组：如 `useRequest` 返回 `{ data, loading, error, refresh }`，方便外部按需解构；
- 避免返回冗余数据：仅返回外部需要的状态/方法，减少不必要的重渲染。

## 2.4 内部 Hooks 调用合规
自定义 Hooks 本质是 Hooks 函数的组合，需严格遵守 React Hooks 规则：
- 只能在自定义 Hooks 内部、函数组件或其他 Hooks 中调用 React 内置 Hooks；
- 不能在条件语句、循环、嵌套函数中调用 Hooks；
- 确保 Hooks 调用顺序固定。

## 2.5 错误处理与边界兼容
对可能出现的异常（如网络请求失败、本地存储无权限）进行捕获，并提供默认值或错误回调，避免 Hooks 执行崩溃影响组件。
```jsx
function useLocalStorage(key, initialValue) {
  const [value, setValue] = useState(() => {
    try {
      // 尝试从本地存储读取，失败则返回初始值
      const stored = localStorage.getItem(key);
      return stored ? JSON.parse(stored) : initialValue;
    } catch (error) {
      console.error("读取本地存储失败：", error);
      return initialValue;
    }
  });
  // ... 其他逻辑
}
```

## 2.6 避免过度封装
仅封装**真正可复用**的逻辑，若某段逻辑仅在单个组件中使用，无需封装为自定义 Hooks，避免增加不必要的抽象层。

# 3. 其他设计细节
1. **参数默认值**：为非必传参数设置合理默认值，提升易用性。
   ```jsx
   // useDebounce 默认延迟 500ms
   function useDebounce(value, delay = 500) { /* ... */ }
   ```
2. **注释说明**：为自定义 Hooks 添加清晰注释，说明功能、参数、返回值、使用场景，降低协作成本。
3. **避免副作用泄漏**：内部的定时器、事件监听、网络请求等，需通过清理函数（如 `useEffect` 的返回函数）销毁，防止内存泄漏。', '9e07a04e-b6bb-488a-9725-08821605cfbc', 'true', '2025-12-22 02:22:16.74988+00', '2025-12-22 02:46:13.871809+00'), ('778db0ce-a6b3-45fd-a3c6-e71f3029b659', 'JSX 与 HTML 的区别', '
JSX 虽然看起来和 HTML 很像，但本质是 JavaScript 语法糖，因此在语法、属性名、关键字等方面存在诸多区别。下面是两者的核心区别对比：

# 1. 核心区别对照表
| 对比维度 | HTML | JSX | 说明 |
|----------|------|-----|------|
| 根节点要求 | 无强制要求，可多个根节点 | 必须有且仅有一个根节点（或用 Fragment 包裹） | JSX 编译后是函数调用，只能返回一个值 |
| 类名属性 | `class` | `className` | `class` 是 JavaScript 关键字，避免冲突 |
| 标签闭合 | 部分标签可省略闭合（如 `<img>`、`<br>`） | 所有标签必须闭合（如 `<img />`、`<br />`） | 遵循 XML 严格语法规则 |
| 事件属性 | 全小写（如 `onclick`、`onchange`） | 驼峰命名（如 `onClick`、`onChange`） | 与 JavaScript 事件处理函数命名一致 |
| `for` 属性 | `for`（如 `<label for="input1">`） | `htmlFor` | `for` 是 JavaScript 循环关键字，避免冲突 |
| 样式设置 | `style="color: red; font-size: 16px;"` | `style={{ color: ''red'', fontSize: ''16px'' }}` | JSX 样式是 JavaScript 对象 |
| 表达式嵌入 | 不支持 | 支持 `{}` 嵌入 JavaScript 表达式 | 这是 JSX 的核心特性 |
| 注释写法 | `<!-- 注释内容 -->` | `{/* 注释内容 */}` | JSX 注释需要写在 `{}` 内 |

# 2. 重点区别详解
## （1）类名属性：`class` → `className`
在 HTML 中，我们使用 `class` 属性为元素设置样式类名，但在 JSX 中不能直接使用 `class`，因为 `class` 是 JavaScript 的**关键字**（用于定义类），为了避免语法冲突，JSX 规定使用 `className` 替代 `class`。

**示例对比**：
```html
<!-- HTML 写法 -->
<div class="container">这是 HTML 元素</div>
```

```jsx
// JSX 写法
<div className="container">这是 JSX 元素</div>
```

## （2）`for` 属性 → `htmlFor`
在 HTML 中，`<label>` 标签的 `for` 属性用于关联 `<input>` 元素（点击 label 可触发 input 聚焦）。但 `for` 是 JavaScript 的**循环关键字**，因此 JSX 中使用 `htmlFor` 替代 `for`。

**示例对比**：
```html
<!-- HTML 写法 -->
<label for="username">用户名：</label>
<input type="text" id="username">
```

```jsx
// JSX 写法
<label htmlFor="username">用户名：</label>
<input type="text" id="username" />
```

## （3）事件属性：全小写 → 驼峰命名
HTML 中的事件属性是全小写形式（如 `onclick`、`onmouseover`），而 JSX 中的事件属性采用**驼峰命名法**（如 `onClick`、`onMouseOver`），这与 JavaScript 中 DOM 事件的处理函数命名规则一致。

**示例对比**：
```html
<!-- HTML 写法 -->
<button onclick="alert(''点击了按钮'')">点击我</button>
```

```jsx
// JSX 写法
<button onClick={() => alert(''点击了按钮'')}>点击我</button>
```

## （4）自闭合标签
HTML 中部分标签可以省略闭合符号（如 `<img>`、`<br>`、`<input>`），但 JSX 遵循 XML 语法规则，**所有标签必须闭合**，自闭合标签需要添加 `/`。

**示例对比**：
```html
<!-- HTML 写法 -->
<img src="logo.png" alt="logo">
<br>
<input type="text">
```

```jsx
// JSX 写法
<img src="logo.png" alt="logo" />
<br />
<input type="text" />
```

# 3. 其他细节区别
1. **布尔属性处理**：HTML 中布尔属性只要存在，值就为 `true`（如 `<input disabled>` 表示禁用）；JSX 中布尔属性需要显式设置值为 `true` 或 `false`，或者省略属性表示 `false`。
   ```jsx
   // 禁用按钮
   <input type="text" disabled={true} />
   // 不禁用按钮（省略 disabled 属性）
   <input type="text" />
   ```
2. **特殊字符处理**：HTML 中可以直接使用 `<`、`>` 等特殊字符；JSX 中需要使用转义字符（如 `<` → `&lt;`，`>` → `&gt;`），或者在 `{}` 中嵌入表达式。
   ```jsx
   // 正确写法：转义字符
   <p>1 &lt; 2</p>
   // 正确写法：表达式
   <p>{1 < 2 ? ''1 小于 2'' : ''1 大于 2''}</p>
   ```', '22e948d7-98f2-4c47-8ae2-4abb0990f9f7', 'true', '2025-12-19 07:35:24.737495+00', '2025-12-19 09:20:29.769605+00'), ('780d7bf0-97a9-4550-bab4-2cc28f910bf1', 'React 18 新特性', 'React 18 的核心升级是引入**并发渲染（Concurrent Rendering）**，这是一种底层架构优化，允许 React 在渲染过程中暂停、恢复或中断任务，优先处理高优先级操作（如用户输入、动画），从而提升应用的响应速度和用户体验。同时，React 18 提供了 `useTransition`、`useDeferredValue` 等新 API，让开发者能够利用并发渲染能力。

# 1. 并发渲染（Concurrent Rendering）
## 1.1 核心概念
并发渲染是 React 18 的底层引擎升级，它将渲染过程从“同步不可中断”改为“异步可中断”：
- **同步渲染**（React 17 及之前）：一旦开始渲染，必须执行到底，期间阻塞浏览器主线程（导致用户交互无响应）；
- **并发渲染**（React 18）：渲染过程可被高优先级任务（如点击、输入、动画）中断，完成高优先级任务后再继续渲染，避免页面卡顿。

## 1.2 关键特性
1. **渲染优先级**：React 为不同任务分配优先级（如用户输入 > 动画 > 数据加载 > 普通渲染），高优先级任务可中断低优先级任务；
2. **非阻塞渲染**：渲染过程不阻塞浏览器主线程，保证页面交互流畅；
3. **可选特性**：并发渲染不会自动启用，需通过新的根 API（`createRoot`）激活。

## 1.3 启用并发渲染
React 18 中，需将 `ReactDOM.render` 替换为 `createRoot` 以启用并发渲染：
```javascript
// React 17 及之前
import ReactDOM from ''react-dom'';
ReactDOM.render(<App />, document.getElementById(''root''));

// React 18
import { createRoot } from ''react-dom/client'';
const root = createRoot(document.getElementById(''root''));
root.render(<App />);
```

# 2. 自动批处理（Automatic Batching）
## 2.1 核心概念
批处理是 React 将多个状态更新合并为一次渲染的优化策略，减少渲染次数，提升性能。React 18 之前，批处理仅在事件处理函数中生效；React 18 实现了**自动批处理**，无论状态更新发生在何处（事件处理、Promise 回调、定时器、异步函数），都会被合并为一次渲染。

## 2.2 对比示例
```javascript
// React 17 及之前：仅事件处理函数内的更新会批处理
function Example() {
  const [count, setCount] = useState(0);
  const [text, setText] = useState('''');

  // 事件处理函数：批处理（1 次渲染）
  const handleClick = () => {
    setCount(c => c + 1);
    setText(t => t + ''a'');
  };

  // Promise 回调：不批处理（2 次渲染）
  const handlePromise = () => {
    fetch(''/api/data'').then(() => {
      setCount(c => c + 1);
      setText(t => t + ''a'');
    });
  };

  return (
    <div>
      <button onClick={handleClick}>点击（批处理）</button>
      <button onClick={handlePromise}>Promise（不批处理）</button>
    </div>
  );
}

// React 18（createRoot 启用）：所有更新自动批处理（均为 1 次渲染）
function Example() {
  // 同上代码，handlePromise 中的更新也会被批处理
}
```

## 2.3 手动取消批处理
若需立即触发渲染（不批处理），可使用 `flushSync`：
```javascript
import { flushSync } from ''react-dom'';

function handleClick() {
  flushSync(() => {
    setCount(c => c + 1); // 立即渲染
  });
  setText(t => t + ''a''); // 单独渲染
}
```

# 3. useTransition：标记非紧急更新
## 3.1 核心概念
`useTransition` 是 React 18 新增的 Hook，用于将状态更新标记为“非紧急更新”（transition），让 React 优先处理紧急更新（如用户输入），待主线程空闲时再执行非紧急更新，避免页面卡顿。

## 3.2 基本用法
```javascript
import { useState, useTransition } from ''react'';

function SearchComponent() {
  const [input, setInput] = useState('''');
  const [results, setResults] = useState([]);
  // isPending：是否正在执行 transition 更新；startTransition：标记非紧急更新
  const [isPending, startTransition] = useTransition();

  // 处理输入（紧急更新）
  const handleInputChange = (e) => {
    const value = e.target.value;
    // 紧急更新：立即更新输入框内容
    setInput(value);

    // 非紧急更新：搜索结果（耗时操作）
    startTransition(() => {
      // 模拟耗时搜索
      const filteredResults = largeData.filter(item => 
        item.includes(value)
      );
      setResults(filteredResults);
    });
  };

  return (
    <div>
      <input 
        type="text" 
        value={input} 
        onChange={handleInputChange} 
        placeholder="搜索..." 
      />
      {/* 加载状态提示 */}
      {isPending && <div>搜索中...</div>}
      <ul>
        {results.map((item, index) => (
          <li key={index}>{item}</li>
        ))}
      </ul>
    </div>
  );
}
```

## 3.3 关键特性
1. **优先级控制**：`startTransition` 包裹的状态更新优先级低于紧急更新（如输入、点击），不会阻塞用户交互；
2. **加载状态**：`isPending` 标识 transition 更新是否进行中，可用于显示加载提示；
3. **中断性**：若在 transition 更新过程中触发新的紧急更新，React 会中断当前 transition，优先处理紧急更新；
4. **无延迟执行**：transition 不会延迟更新执行，只是允许被中断，保证页面响应性。

# 4. useDeferredValue：延迟更新值
## 4.1 核心概念
`useDeferredValue` 是 React 18 新增的 Hook，用于创建一个“延迟更新”的变量副本，该副本会在紧急更新完成后才更新，适用于将昂贵的计算或渲染与紧急更新解耦。

## 4.2 基本用法
```javascript
import { useState, useDeferredValue } from ''react'';

function ListComponent() {
  const [input, setInput] = useState('''');
  // 创建延迟更新的 input 副本（deferredInput 会滞后于 input 更新）
  const deferredInput = useDeferredValue(input, {
    timeoutMs: 200 // 可选：延迟最长时间（毫秒）
  });

  // 基于 deferredInput 渲染列表（昂贵操作）
  const results = largeData.filter(item => 
    item.includes(deferredInput)
  );

  return (
    <div>
      <input 
        type="text" 
        value={input} 
        onChange={(e) => setInput(e.target.value)} 
      />
      <ul>
        {results.map((item, index) => (
          <li key={index}>{item}</li>
        ))}
      </ul>
    </div>
  );
}
```

## 4.3 与 useTransition 的区别
| 特性 | useTransition | useDeferredValue |
|------|---------------|------------------|
| 作用对象 | 状态更新（setState） | 变量值（创建延迟副本） |
| 使用场景 | 标记非紧急状态更新 | 延迟使用某个值（如过滤条件） |
| 加载状态 | 提供 isPending 标识 | 无内置加载状态（需自行处理） |
| 中断性 | 支持中断 | 支持中断 |

# 5. 其他 React 18 新特性
## 5.1 Suspense 增强
React 18 中，Suspense 不再局限于懒加载组件，还支持：
- 数据加载：配合 Suspense-compatible 数据库（如 Relay、React Query）实现数据加载时的占位符；
- 流式渲染：逐步渲染页面内容，优先显示关键内容；
- 服务端渲染：支持服务端流式渲染，提升首屏加载速度。

## 5.2 新的客户端渲染 API
- `createRoot`：替代 `ReactDOM.render`，启用并发渲染；
- `hydrateRoot`：替代 `ReactDOM.hydrate`，支持服务端渲染的并发 hydration。

## 5.3 严格模式升级
React 18 严格模式会在开发环境下**两次挂载组件**，检测组件是否存在副作用（如未清除的定时器、事件监听），帮助开发者编写更健壮的代码。

# 6. 最佳实践
1. **优先使用 createRoot**：启用并发渲染，享受自动批处理等优化；
2. **区分紧急/非紧急更新**：用户输入、动画等紧急操作优先处理，数据加载、列表过滤等非紧急操作使用 `useTransition`/`useDeferredValue`；
3. **合理使用 Suspense**：为懒加载组件、数据加载场景提供友好的占位符；
4. **避免滥用 transition**：仅对耗时操作使用 `useTransition`，简单更新无需标记；
5. **兼容旧代码**：React 18 保持向下兼容，旧代码使用 `ReactDOM.render` 仍可运行（但不启用并发渲染）。', '0fa74abf-556e-40ef-a0d4-33dc2f8648a5', 'true', '2025-12-22 03:18:06.752891+00', '2025-12-23 10:01:43.615629+00'), ('7a5fe8e0-83a9-417d-819f-bb5eb666339e', 'useId：生成唯一 ID', '# 1. 核心概念
`useId` 是 React 18 新增的 Hook，用于**生成跨服务端和客户端的唯一 ID**，解决了传统 ID 生成方案（如随机数、时间戳）在服务端渲染（SSR）时的“不匹配”问题（服务端生成的 ID 与客户端生成的 ID 不一致，导致 hydration 错误）。

## 1.1 设计目的：
- 支持 SSR/SSG：服务端和客户端生成相同的 ID，避免 hydration 不匹配；
- 无障碍（a11y）适配：为表单控件（如 input/label）、ARIA 属性（如 aria-labelledby）提供唯一关联 ID；
- 避免 ID 冲突：在循环渲染、组件复用场景下生成唯一 ID。

# 2. 基本用法
## 2.1 基础使用（表单 label 关联）
```javascript
import { useId } from ''react'';

function InputWithLabel() {
  // 生成唯一 ID
  const inputId = useId();

  return (
    <div>
      {/* label 与 input 通过 ID 关联（无障碍必备） */}
      <label htmlFor={inputId}>用户名：</label>
      <input id={inputId} type="text" />
    </div>
  );
}
```

## 2.2 生成多个关联 ID
```javascript
import { useId } from ''react'';

function FormGroup() {
  // 生成根 ID，基于根 ID 派生子 ID
  const rootId = useId();
  const usernameId = `${rootId}-username`;
  const passwordId = `${rootId}-password`;

  return (
    <div>
      <label htmlFor={usernameId}>用户名：</label>
      <input id={usernameId} type="text" />

      <label htmlFor={passwordId}>密码：</label>
      <input id={passwordId} type="password" />
    </div>
  );
}
```

## 2.3 循环渲染中生成唯一 ID
```javascript
import { useId } from ''react'';

function CheckboxGroup({ options }) {
  const rootId = useId();

  return (
    <div>
      {options.map((option) => {
        // 为每个选项生成唯一 ID
        const checkboxId = `${rootId}-${option.value}`;
        return (
          <div key={option.value}>
            <input
              type="checkbox"
              id={checkboxId}
              value={option.value}
            />
            <label htmlFor={checkboxId}>{option.label}</label>
          </div>
        );
      })}
    </div>
  );
}

// 使用组件
function App() {
  const options = [
    { label: ''选项1'', value: ''opt1'' },
    { label: ''选项2'', value: ''opt2'' },
    { label: ''选项3'', value: ''opt3'' }
  ];

  return <CheckboxGroup options={options} />;
}
```

# 3. 关键特性
## 3.1 SSR 兼容性
传统 ID 生成方案（如 `Math.random()`）在 SSR 时会导致服务端和客户端 ID 不一致：
```javascript
// 错误示例：SSR 时服务端和客户端生成的 randomId 不同，触发 hydration 错误
function BadInput() {
  const randomId = `input-${Math.random()}`;
  return <input id={randomId} />;
}

// 正确示例：useId 在服务端和客户端生成相同 ID
function GoodInput() {
  const inputId = useId();
  return <input id={inputId} />;
}
```

## 3.2 ID 格式
`useId` 生成的 ID 格式为 `react-数字-数字`（如 `react-123-456`），确保全局唯一性，且不会泄露敏感信息（与随机数不同）。

## 3.3 依赖项
`useId` 无依赖项，每次组件挂载时生成固定 ID（组件重渲染时 ID 不变）。

# 4. 适用场景
1. **无障碍表单**：label 与 input 关联、aria-describedby/aria-labelledby 等 ARIA 属性；
2. **服务端渲染**：需要保证服务端和客户端 ID 一致的场景；
3. **组件复用**：多个相同组件实例需要唯一 ID（如弹窗、下拉菜单）；
4. **第三方库集成**：为第三方组件（如日历、富文本编辑器）提供唯一挂载 ID。

# 5. 注意事项
1. **不要用于列表 key**：列表 key 需基于数据本身（如 item.id），`useId` 生成的 ID 与数据无关，无法保证组件复用和性能优化；
   ```javascript
   // 错误示例
   {items.map(item => (
     <div key={useId()}>{item.name}</div>
   ))}

   // 正确示例
   {items.map(item => (
     <div key={item.id}>{item.name}</div>
   ))}
   ```
2. **不要用于敏感场景**：`useId` 生成的 ID 不是加密安全的，不能用于身份验证、令牌等场景；
3. **避免过度生成**：优先基于根 ID 派生子 ID（如 `${rootId}-input`），而非多次调用 `useId`；
4. **客户端渲染也可使用**：即使不使用 SSR，`useId` 也是生成唯一 ID 的最佳实践（比随机数更可靠）。
', '0fa74abf-556e-40ef-a0d4-33dc2f8648a5', 'true', '2025-12-22 03:17:53.645259+00', '2025-12-23 10:00:04.890856+00'), ('7b4663e1-2f44-4ecf-8603-2790eaef77ea', 'React 虚拟 DOM 与 Diff 算法', '# 1. 什么是虚拟 DOM（Virtual DOM）
虚拟 DOM 是 React 核心概念之一，本质是**描述真实 DOM 结构的 JavaScript 对象**（简称 VNode），它映射了真实 DOM 的层级关系和属性，存储在内存中，是真实 DOM 的“轻量级副本”。

## 1.1 核心结构（简化版）
```javascript
// 真实 DOM 对应的虚拟 DOM 对象
const vnode = {
  type: ''div'', // 节点类型（标签名/组件）
  props: {
    className: ''container'',
    onClick: handleClick
  },
  children: [
    { type: ''h1'', props: { children: ''Hello React'' } },
    { type: ''p'', props: { children: ''Virtual DOM'' } }
  ],
  key: null // 用于 Diff 算法识别节点唯一性
};
```

## 1.2 虚拟 DOM 的诞生背景
- 真实 DOM 操作性能极低（DOM 节点是重量级对象，频繁增删改查会触发浏览器重排/重绘）；
- 直接操作真实 DOM 难以维护复杂 UI 状态（如状态更新后手动同步 DOM）；
- 虚拟 DOM 以 JS 对象形式存在，操作成本远低于真实 DOM，且能批量更新、按需渲染。

## 1.3 虚拟 DOM 工作流程
1. **初始化渲染**：React 将组件渲染为虚拟 DOM 对象，再通过 `ReactDOM.render` 转换为真实 DOM 插入页面；
2. **状态更新**：组件状态变化时，React 生成新的虚拟 DOM 树；
3. **Diff 对比**：对比新旧虚拟 DOM 树的差异（Diff 算法）；
4. **DOM 打补丁**：将差异部分批量更新到真实 DOM 中（Reconciliation 协调过程）。

# 2. 为什么需要虚拟 DOM
## 2.1 核心价值
1. **性能优化**：
   - 批量更新：将多次 DOM 操作合并为一次，减少浏览器重排/重绘；
   - 按需更新：仅更新变化的部分，而非整个 DOM 树；
   - 跨平台兼容：虚拟 DOM 与平台无关（可渲染到 DOM/原生组件/Canvas 等），是 React Native 实现的基础。

2. **开发体验提升**：
   - 声明式编程：开发者只需描述 UI “应该是什么样”，无需关心 DOM 操作细节；
   - 组件化复用：虚拟 DOM 支持组件嵌套，实现 UI 逻辑复用；
   - 状态驱动 UI：状态变化自动映射到虚拟 DOM，再同步到真实 DOM，无需手动操作。

## 2.2 常见误区
- ❌ “虚拟 DOM 一定比原生 DOM 快”：虚拟 DOM 优势在于**复杂场景下的批量更新和按需渲染**，简单场景（如单次 DOM 修改）原生操作可能更快；
- ✅ 虚拟 DOM 的核心价值是“抽象层”，而非单纯的性能提升，它让 React 实现了跨平台、声明式编程等特性。

# 3. React Diff 算法（虚拟 DOM 对比核心）
Diff 算法是 React 对比新旧虚拟 DOM 树、找出差异的核心逻辑，设计目标是**以最低成本找到差异节点**，其核心原则是：**基于两个假设，降低算法复杂度**（从 O(n³) 降至 O(n)，n 为节点数量）。

## 3.1 核心假设
1. **同层对比**：只对比同一层级的节点，不跨层级比较（如根节点的子节点只和根节点的子节点对比，不会和孙子节点对比）；
   - 若节点跨层级移动，React 会直接删除旧节点、创建新节点，而非移动（这也是为什么不建议频繁跨层级操作 DOM）。
2. **唯一 key 标识**：同一层级的节点通过 `key` 属性标识唯一性，若 `key` 相同则认为是同一节点，否则视为新节点。

## 3.2 Diff 算法执行流程
### 第一步：对比节点类型
- 若新旧节点类型不同（如旧节点是 `div`，新节点是 `p`）：直接销毁旧节点及其所有子节点，创建新节点；
- 若新旧节点类型相同（如都是 `div`）：进入属性对比和子节点对比。

### 第二步：对比节点属性
- 遍历新节点的 `props`，更新差异属性（如 `className`、`style`、事件绑定）；
- 移除旧节点有但新节点没有的属性（如旧节点有 `title`，新节点无，则删除 `title` 属性）。

### 第三步：对比子节点（核心难点）
React 对列表子节点的对比做了专门优化，核心依赖 `key` 属性：

#### 场景 1：无 key 的列表（不推荐）
```jsx
// 旧列表
<ul>
  <li>Item 1</li>
  <li>Item 2</li>
</ul>

// 新列表（在头部插入 Item 0）
<ul>
  <li>Item 0</li>
  <li>Item 1</li>
  <li>Item 2</li>
</ul>
```
- 无 `key` 时，React 按顺序对比：
  1. 第一个 `li`：内容从 `Item 1` 变为 `Item 0` → 更新内容；
  2. 第二个 `li`：内容从 `Item 2` 变为 `Item 1` → 更新内容；
  3. 第三个 `li`：新增 `Item 2` → 创建新节点；
- 结果：3 次 DOM 操作（2 次更新 + 1 次创建），效率极低。

#### 场景 2：有 key 的列表（推荐）
```jsx
// 旧列表
<ul>
  <li key="1">Item 1</li>
  <li key="2">Item 2</li>
</ul>

// 新列表（在头部插入 Item 0）
<ul>
  <li key="0">Item 0</li>
  <li key="1">Item 1</li>
  <li key="2">Item 2</li>
</ul>
```
- 有 `key` 时，React 按 `key` 匹配：
  1. `key="0"`：新节点 → 创建；
  2. `key="1"`：匹配成功 → 无变化；
  3. `key="2"`：匹配成功 → 无变化；
- 结果：仅 1 次 DOM 操作（创建 `key="0"` 节点），效率大幅提升。

## 3.3 key 的使用原则
- ✅ 使用唯一且稳定的值（如数据 ID、后端返回的唯一标识）；
- ❌ 不使用索引（index）作为 key（列表排序/增删时索引会变化，导致 Diff 失效）；
- ❌ 不使用随机数（每次渲染生成新 key，导致节点被频繁销毁重建）。

# 4. 虚拟 DOM 与 Diff 算法的局限性
- 跨层级节点移动：React 会销毁旧节点重建，而非移动（可通过 `ReactTransitionGroup` 优化）；
- 相同组件不同状态：若组件类型相同但状态差异大，Diff 算法仍会对比属性和子节点（可通过 `shouldComponentUpdate`/`memo` 优化）；
- 大量列表渲染：长列表场景下，即使使用 key，Diff 对比仍有性能开销（可通过虚拟列表优化）。', '46554425-2ee6-405b-b46c-7720d50c48ec', 'true', '2025-12-22 03:14:31.066194+00', '2025-12-23 09:29:37.651134+00'), ('7bc1bad8-b500-4705-bf56-5fcad421ec0e', '类组件 state 与 setState', '在 React 类组件中，**state** 是用于存储组件内部可变数据的容器，**setState** 是唯一能合法修改 state 的方法。二者配合实现组件的状态管理与视图更新，其中 `setState` 的**异步更新**和**批量更新**特性是核心知识点，也是开发中容易踩坑的地方。

# 1. state 基础用法
## 1.1 初始化 state
类组件的 state 必须在 `constructor` 构造函数中初始化，或通过类的实例属性直接定义（ES7 语法），state 本质是一个 JavaScript 对象，可存储多个状态属性。
```jsx
import React from ''react'';

class Counter extends React.Component {
  // 方式1：ES7 类实例属性（推荐，简洁）
  state = {
    count: 0,
    message: ''初始消息''
  };

  // 方式2：constructor 构造函数初始化（兼容老版本）
  // constructor(props) {
  //   super(props);
  //   this.state = {
  //     count: 0,
  //     message: ''初始消息''
  //   };
  // }

  render() {
    // 通过 this.state 访问状态
    return (
      <div>
        <p>计数：{this.state.count}</p>
        <p>消息：{this.state.message}</p>
      </div>
    );
  }
}
```

## 1.2 state 的核心特性
- **不可直接修改**：直接修改 `this.state` 不会触发组件重新渲染，必须通过 `setState` 方法更新。
  ```jsx
  // 错误：直接修改 state，组件不更新
  this.state.count = 1;

  // 正确：通过 setState 更新 state
  this.setState({ count: 1 });
  ```
- **状态与视图联动**：调用 `setState` 后，React 会重新执行 `render` 方法，根据新的 state 生成新的 DOM 结构，实现视图更新。
- **独立隔离**：每个类组件实例的 state 都是独立的，不同实例之间的状态互不影响。

# 2. setState 基础用法
`setState` 是 React 提供的用于更新 state 的方法，接收两个参数，语法如下：
```jsx
this.setState(stateChange[, callback]);
// 或
this.setState((prevState, props) => stateChange[, callback]);
```

## 2.1 两种调用方式
### （1）对象式更新（适用于不依赖旧状态的场景）
直接传递一个**状态更新对象**，指定需要修改的属性，未指定的属性会保持不变。
```jsx
class Counter extends React.Component {
  state = { count: 0 };

  handleIncrement = () => {
    // 对象式更新：直接设置新值
    this.setState({ count: this.state.count + 1 });
  };

  render() {
    return (
      <div>
        <p>计数：{this.state.count}</p>
        <button onClick={this.handleIncrement}>+1</button>
      </div>
    );
  }
}
```

### （2）函数式更新（适用于依赖旧状态的场景）
传递一个**回调函数**，函数接收两个参数：`prevState`（更新前的 state）和 `props`（当前组件的 props），返回一个状态更新对象。
```jsx
class Counter extends React.Component {
  state = { count: 0 };

  handleIncrement = () => {
    // 函数式更新：依赖旧状态计算新值
    this.setState((prevState, props) => {
      return { count: prevState.count + 1 };
    });
  };

  render() {
    return (
      <div>
        <p>计数：{this.state.count}</p>
        <button onClick={this.handleIncrement}>+1</button>
      </div>
    );
  }
}
```

## 2.2 第二个参数：更新完成后的回调
`setState` 的第二个参数是一个可选的回调函数，会在**状态更新完成且组件重新渲染后**执行，可用于获取更新后的 DOM 或执行后续逻辑。
```jsx
handleIncrement = () => {
  this.setState({ count: this.state.count + 1 }, () => {
    // 回调函数中：state 已更新，DOM 已重新渲染
    console.log(''更新后的 count：'', this.state.count);
    console.log(''DOM 中的计数：'', document.querySelector(''p'').innerText);
  });

  // 这里的 state 还是更新前的值（因为 setState 是异步的）
  console.log(''当前 count：'', this.state.count);
};
```

# 3. setState 异步更新特性
## 3.1 核心表现
在 React 合成事件（如 `onClick`、`onChange`）和生命周期钩子（如 `componentDidMount`）中，`setState` 是**异步执行**的：调用 `setState` 后，不会立即更新 `this.state`，而是将状态更新请求加入队列，等待合适的时机批量处理。
```jsx
class Counter extends React.Component {
  state = { count: 0 };

  handleIncrement = () => {
    console.log(''更新前 count：'', this.state.count); // 输出 0

    this.setState({ count: this.state.count + 1 });
    console.log(''调用 setState 后 count：'', this.state.count); // 输出 0（异步未更新）
  };

  render() {
    return <button onClick={this.handleIncrement}>+1</button>;
  }
}
```

## 3.2 为什么要设计成异步？
- **性能优化**：避免频繁的 state 更新导致组件反复渲染，React 会将多个 `setState` 请求合并为一次更新，减少 DOM 操作次数。
- **保证状态一致性**：确保组件状态和 DOM 状态同步，避免中间状态导致的 UI 混乱。

## 3.3 如何获取异步更新后的状态？
有两种可靠方式获取更新后的 state：
- **使用 setState 的第二个参数（回调函数）**：如上文示例，回调函数会在状态更新完成后执行。
- **在 componentDidUpdate 生命周期钩子中获取**：该钩子会在组件更新完成后触发。
  ```jsx
  componentDidUpdate(prevProps, prevState) {
    // 状态更新完成后执行
    console.log(''更新后的 count：'', this.state.count);
  }
  ```

## 3.4 特殊场景：setState 同步更新
在**原生 JavaScript 事件**（如 `addEventListener` 绑定的事件）、**定时器**（`setTimeout`/`setInterval`）、**异步函数**（`Promise.then`）中，`setState` 是**同步执行**的，调用后会立即更新 `this.state`。
```jsx
class Counter extends React.Component {
  state = { count: 0 };

  componentDidMount() {
    // 原生事件：setState 同步更新
    document.getElementById(''btn'').addEventListener(''click'', () => {
      this.setState({ count: this.state.count + 1 });
      console.log(''原生事件中 count：'', this.state.count); // 输出 1
    });

    // 定时器：setState 同步更新
    setTimeout(() => {
      this.setState({ count: this.state.count + 1 });
      console.log(''定时器中 count：'', this.state.count); // 输出 2
    }, 1000);
  }

  render() {
    return <button id="btn">原生事件按钮</button>;
  }
}
```

# 4. setState 批量更新特性
## 4.1 核心表现
在 React 合成事件和生命周期钩子中，**多次调用 setState 会被合并为一次更新**，最终只触发一次 `render` 方法。
```jsx
class Counter extends React.Component {
  state = { count: 0 };

  handleBatchUpdate = () => {
    // 连续调用 3 次 setState
    this.setState({ count: this.state.count + 1 });
    this.setState({ count: this.state.count + 1 });
    this.setState({ count: this.state.count + 1 });
    // 最终 count 只增加 1，因为三次更新都基于同一个旧状态（0）
  };

  render() {
    console.log(''执行 render 方法'');
    return (
      <div>
        <p>计数：{this.state.count}</p>
        <button onClick={this.handleBatchUpdate}>批量更新</button>
      </div>
    );
  }
}
```
点击按钮后，控制台只会输出一次 `执行 render 方法`，且 `count` 最终值为 `1`，而非 `3`。

## 4.2 解决批量更新的依赖问题
批量更新导致的问题本质是：多次更新都基于**同一个旧状态**计算新值。解决方法是使用**函数式更新**，因为函数式更新的回调函数会接收最新的 `prevState`（每次更新后的状态）。
```jsx
handleBatchUpdate = () => {
  // 函数式更新：每次都基于最新的 prevState 计算
  this.setState(prevState => ({ count: prevState.count + 1 }));
  this.setState(prevState => ({ count: prevState.count + 1 }));
  this.setState(prevState => ({ count: prevState.count + 1 }));
  // 最终 count 增加 3，达到预期效果
};
```

# 5. 核心总结
1. **state 初始化**：类组件可通过类实例属性或 `constructor` 初始化 state，state 是不可直接修改的对象。
2. **setState 两种方式**：
   - 对象式更新：适用于不依赖旧状态的场景。
   - 函数式更新：适用于依赖旧状态或批量更新的场景，推荐优先使用。
3. **异步更新特性**：
   - React 合成事件和生命周期钩子中，`setState` 是异步的，需通过回调函数或 `componentDidUpdate` 获取更新后的状态。
   - 原生事件、定时器、异步函数中，`setState` 是同步的。
4. **批量更新特性**：
   - 合成事件和生命周期中，多次 `setState` 会合并为一次更新，减少渲染次数。
   - 依赖旧状态的批量更新，必须使用函数式更新。
', 'e42a3397-52b2-470f-a87d-08e025ba6944', 'true', '2025-12-19 11:37:25.28939+00', '2025-12-19 11:37:25.28939+00'), ('7c078f52-9a91-417a-82e6-3aac1b24e90b', 'useContext：跨组件取值', '在 React 组件树中，组件之间的通信通常通过 `props` 实现，但当组件层级较深（如爷爷组件 → 父组件 → 子组件 → 孙组件）时，逐层传递 `props` 会导致“props 透传”问题（中间组件无需使用该数据，却必须中转传递），代码冗余且维护成本高。`useContext` 是 React 提供的用于解决**跨层级组件通信**的 Hook，配合 `createContext` 可实现数据的“全局共享”，让任意层级的组件直接访问共享数据。

# 1. Context 核心概念与工作流程
## 1.1 什么是 Context？
Context 是 React 提供的一种“上下文”机制，用于在组件树中共享**全局数据**（如主题、用户信息、权限配置），避免 props 透传。Context 包含三个核心部分：
- **Context 对象**：通过 `React.createContext` 创建，用于存储共享数据的容器。
- **Provider 组件**：Context 对象的属性，用于“提供”数据，包裹需要共享数据的组件树。
- **Consumer**：用于“消费”数据（类组件使用 `Context.Consumer`，函数组件使用 `useContext`）。

## 1.2 useContext 工作流程
1. **创建 Context**：使用 `createContext` 创建 Context 对象，可指定默认值（仅在无 Provider 时生效）。
2. **提供数据**：使用 `Context.Provider` 包裹组件树，通过 `value` 属性传递共享数据。
3. **消费数据**：在任意子组件中使用 `useContext(Context)` 获取共享数据，无需逐层传递 props。

# 2. useContext 基础用法
## 步骤1：创建 Context 对象
推荐将 Context 单独封装在一个文件中，便于复用和维护：
```jsx
// src/contexts/ThemeContext.js
import { createContext } from ''react'';

// 创建 Context，指定默认值（仅无 Provider 时生效）
const ThemeContext = createContext({
  theme: ''light'', // 默认主题：亮色
  toggleTheme: () => {} // 默认空函数
});

export default ThemeContext;
```

## 步骤2：使用 Provider 提供数据
在组件树的顶层组件（如 App 组件）中，使用 `ThemeContext.Provider` 包裹子组件，并通过 `value` 属性传递共享数据（状态 + 方法）：
```jsx
// src/App.jsx
import { useState } from ''react'';
import ThemeContext from ''./contexts/ThemeContext'';
import ParentComponent from ''./ParentComponent'';

function App() {
  // 共享状态：主题
  const [theme, setTheme] = useState(''light'');

  // 共享方法：切换主题
  const toggleTheme = () => {
    setTheme(prev => prev === ''light'' ? ''dark'' : ''light'');
  };

  // 传递给 Provider 的 value（包含状态和方法）
  const themeValue = {
    theme,
    toggleTheme
  };

  return (
    {/* Provider 包裹需要共享数据的组件树 */}
    <ThemeContext.Provider value={themeValue}>
      <div className={`app ${theme}`}>
        <h1>Context 示例</h1>
        <ParentComponent />
      </div>
    </ThemeContext.Provider>
  );
}

export default App;
```

## 步骤3：使用 useContext 消费数据
在任意层级的子组件中（即使是深层子组件），使用 `useContext` 获取共享数据，无需 props 传递：
```jsx
// src/ParentComponent.jsx（中间组件，无需透传数据）
import ChildComponent from ''./ChildComponent'';

function ParentComponent() {
  // 中间组件无需处理主题数据，直接渲染子组件
  return (
    <div className="parent">
      <h2>父组件</h2>
      <ChildComponent />
    </div>
  );
}

export default ParentComponent;
```

```jsx
// src/ChildComponent.jsx（深层子组件，消费数据）
import { useContext } from ''react'';
import ThemeContext from ''./contexts/ThemeContext'';

function ChildComponent() {
  // 使用 useContext 获取共享数据
  const { theme, toggleTheme } = useContext(ThemeContext);

  return (
    <div className={`child ${theme}`}>
      <h3>子组件（当前主题：{theme}）</h3>
      <button onClick={toggleTheme}>切换主题</button>
    </div>
  );
}

export default ChildComponent;
```

# 3. Context 默认值的生效条件
`createContext(defaultValue)` 中的默认值**仅在以下场景生效**：
1. 组件没有被对应的 `Context.Provider` 包裹。
2. 组件所在的组件树中，没有找到匹配的 `Context.Provider`。

默认值**不会**在 `Provider` 的 `value` 为 `undefined` 时生效：
```jsx
// 场景1：无 Provider，使用默认值
function NoProviderComponent() {
  const { theme } = useContext(ThemeContext);
  console.log(theme); // 输出：light（默认值）
  return <div>无 Provider 组件</div>;
}

// 场景2：有 Provider 但 value 为 undefined，不使用默认值
function UndefinedValueComponent() {
  return (
    <ThemeContext.Provider value={undefined}>
      <ChildComponent /> {/* 子组件获取到的 theme 为 undefined */}
    </ThemeContext.Provider>
  );
}
```

# 4. 多 Context 联合使用
实际开发中，往往需要共享多种类型的数据（如主题、用户信息），此时可创建多个独立的 Context，并嵌套使用 `Provider`，子组件通过多次调用 `useContext` 获取不同的 Context 数据。

## 4.1 创建多个 Context
```jsx
// src/contexts/UserContext.js
import { createContext } from ''react'';

const UserContext = createContext({
  name: ''匿名用户'',
  role: ''guest''
});

export default UserContext;
```

## 4.2 嵌套 Provider 提供数据
```jsx
// src/App.jsx
import { useState } from ''react'';
import ThemeContext from ''./contexts/ThemeContext'';
import UserContext from ''./contexts/UserContext'';
import ChildComponent from ''./ChildComponent'';

function App() {
  const [theme, setTheme] = useState(''light'');
  const [user, setUser] = useState({ name: ''React 开发者'', role: ''admin'' });

  return (
    {/* 嵌套 Provider，顺序不影响 */}
    <UserContext.Provider value={user}>
      <ThemeContext.Provider value={{ theme, toggleTheme: () => setTheme(prev => prev === ''light'' ? ''dark'' : ''light'') }}>
        <ChildComponent />
      </ThemeContext.Provider>
    </UserContext.Provider>
  );
}
```

## 4.3 消费多个 Context 数据
```jsx
// src/ChildComponent.jsx
import { useContext } from ''react'';
import ThemeContext from ''./contexts/ThemeContext'';
import UserContext from ''./contexts/UserContext'';

function ChildComponent() {
  // 多次调用 useContext，获取不同的 Context 数据
  const { theme, toggleTheme } = useContext(ThemeContext);
  const { name, role } = useContext(UserContext);

  return (
    <div className={theme}>
      <p>当前用户：{name}（角色：{role}）</p>
      <p>当前主题：{theme}</p>
      <button onClick={toggleTheme}>切换主题</button>
    </div>
  );
}
```

# 5. useContext 性能优化
## 5.1 问题：Provider 的 value 变化导致子组件重渲染
当 `Context.Provider` 的 `value` 属性发生变化（引用变化）时，所有消费该 Context 的子组件都会重新渲染，即使子组件只使用了 `value` 中的部分数据。

### 示例：不必要的重渲染
```jsx
// App.jsx
function App() {
  const [theme, setTheme] = useState(''light'');
  const [count, setCount] = useState(0);

  // 每次渲染都会创建新的对象（引用变化），导致子组件重渲染
  const value = {
    theme,
    toggleTheme: () => setTheme(prev => prev === ''light'' ? ''dark'' : ''light'')
  };

  return (
    <ThemeContext.Provider value={value}>
      <ChildComponent />
      <button onClick={() => setCount(count + 1)}>计数+1</button>
    </ThemeContext.Provider>
  );
}
```
上述代码中，点击“计数+1”按钮会导致 `App` 组件重新渲染，创建新的 `value` 对象（引用变化），即使 `theme` 没有变化，`ChildComponent` 也会重新渲染。

## 5.2 优化方案
### 方案1：使用 useMemo 缓存 value 对象
通过 `useMemo` 缓存 `value` 对象，仅当依赖项变化时才创建新对象：
```jsx
function App() {
  const [theme, setTheme] = useState(''light'');
  const [count, setCount] = useState(0);

  // 使用 useMemo 缓存 value，仅 theme 变化时更新
  const value = useMemo(() => ({
    theme,
    toggleTheme: () => setTheme(prev => prev === ''light'' ? ''dark'' : ''light'')
  }), [theme]);

  return (
    <ThemeContext.Provider value={value}>
      <ChildComponent />
      <button onClick={() => setCount(count + 1)}>计数+1</button>
    </ThemeContext.Provider>
  );
}
```

### 方案2：拆分 Context
将大的 Context 拆分为多个小的 Context，让子组件仅消费需要的 Context，避免因无关数据变化导致重渲染：
```jsx
// 拆分主题状态和主题方法为两个 Context
const ThemeStateContext = createContext(''light'');
const ThemeActionContext = createContext(() => {});

// Provider 分别提供数据
function ThemeProvider({ children }) {
  const [theme, setTheme] = useState(''light'');
  const toggleTheme = () => setTheme(prev => prev === ''light'' ? ''dark'' : ''light'');

  return (
    <ThemeStateContext.Provider value={theme}>
      <ThemeActionContext.Provider value={toggleTheme}>
        {children}
      </ThemeActionContext.Provider>
    </ThemeStateContext.Provider>
  );
}

// 子组件按需消费
function ChildComponent() {
  const theme = useContext(ThemeStateContext); // 仅依赖主题状态
  return <p>当前主题：{theme}</p>;
}
```

### 方案3：使用 React.memo 包装纯组件
对于仅展示数据的纯组件，使用 `React.memo` 包装，避免不必要的重渲染：
```jsx
// ChildComponent.jsx
import { memo, useContext } from ''react'';
import ThemeContext from ''./contexts/ThemeContext'';

// 使用 memo 包装，仅 props 或 Context 数据变化时重渲染
const ChildComponent = memo(() => {
  const { theme } = useContext(ThemeContext);
  console.log(''ChildComponent 渲染'');
  return <p>当前主题：{theme}</p>;
});

export default ChildComponent;
```

# 6. useContext 与其他通信方案的对比
| 通信方案       | 适用场景                     | 优点                     | 缺点                     |
|----------------|------------------------------|--------------------------|--------------------------|
| props 传递     | 父子组件、层级较浅的组件     | 简单直观，无额外 API      | 层级深时 props 透传      |
| useContext     | 跨层级组件、全局共享数据     | 避免 props 透传，代码简洁 | 过度使用导致组件耦合度高 |
| Redux/Zustand  | 大型应用、全局复杂状态管理   | 状态管理集中，支持中间件  | 学习成本高，配置繁琐     |

# 7. 核心总结
1. **核心作用**：解决跨层级组件通信问题，避免 props 透传，实现全局数据共享。
2. **基本用法**：
   - `createContext` 创建 Context 对象。
   - `Context.Provider` 提供数据（value 属性）。
   - `useContext(Context)` 消费数据。
3. **性能优化**：
   - 使用 `useMemo` 缓存 Provider 的 value 对象，避免不必要的重渲染。
   - 拆分 Context，按需消费，减少组件依赖。
   - 使用 `React.memo` 包装纯组件，优化渲染性能。
4. **使用场景**：
   - 全局共享数据（主题、用户信息、权限配置）。
   - 跨层级组件通信（层级 ≥3 层）。
   - 避免滥用：局部组件通信优先使用 props，全局复杂状态优先使用 Redux/Zustand。...', '8ef7f873-12e2-4aaf-933f-26eddf895f27', 'true', '2025-12-19 15:11:24.370221+00', '2025-12-22 02:03:16.808099+00'), ('7c964cbe-c2d9-473f-86cb-be3a904ac4ba', 'useRef：DOM 引用与持久化变量', '`useRef` 是 React 中用于创建“持久化引用”的 Hook，核心作用有两个：一是获取 DOM 元素的引用（替代类组件的 `createRef`），二是存储组件生命周期内持久不变的值（不会因组件重新渲染而重置）。`useRef` 提供了一种在函数组件中保存“跨渲染数据”的方案，且修改其值不会触发组件重新渲染。

# 1. useRef 基础语法与核心特性
## 1.1 基本语法
```jsx
import { useRef } from ''react'';

function MyComponent() {
  // 创建 ref 对象，initialValue 为初始值（可选）
  const refContainer = useRef(initialValue);

  // ref 对象的核心属性：current，用于存储引用值
  // 读取：refContainer.current
  // 修改：refContainer.current = newValue

  return <div ref={refContainer}>Hello useRef</div>;
}
```

## 1.2 核心特性
- **持久化**：`ref.current` 中存储的值在组件整个生命周期内保持不变，组件重新渲染时不会重置。
- **非响应式**：修改 `ref.current` 的值不会触发组件重新渲染（这是与 `useState` 的核心区别）。
- **通用性**：可存储任意类型的值（DOM 元素、普通变量、对象、函数等）。

## 2. 场景1：获取 DOM 元素引用（DOM 操作）
在 React 中，直接操作 DOM 是不推荐的，但某些场景下（如获取 DOM 尺寸、聚焦输入框、播放视频）必须操作 DOM，`useRef` 是官方推荐的 DOM 引用方案。

## 2.1 基础用法：获取单个 DOM 元素
```jsx
import { useRef, useEffect } from ''react'';

function InputFocus() {
  // 创建 ref 对象，用于引用 input 元素
  const inputRef = useRef(null);

  useEffect(() => {
    // 组件挂载后，通过 inputRef.current 获取 DOM 元素并聚焦
    inputRef.current.focus();
  }, []);

  return (
    <input
      ref={inputRef} // 将 ref 绑定到 input 元素
      type="text"
      placeholder="自动聚焦的输入框"
    />
  );
}
```

## 2.2 进阶用法：获取列表中的 DOM 元素
若需获取列表中多个 DOM 元素，可创建 ref 数组：
```jsx
import { useRef, useEffect } from ''react'';

function ListRef() {
  // 创建 ref 数组，存储多个 DOM 引用
  const itemRefs = useRef([]);

  useEffect(() => {
    // 打印第一个列表项的 DOM 元素
    console.log(itemRefs.current[0]);
  }, []);

  const items = [''Item 1'', ''Item 2'', ''Item 3''];

  return (
    <ul>
      {items.map((item, index) => (
        <li
          key={index}
          // 动态绑定 ref 到数组对应位置
          ref={el => itemRefs.current[index] = el}
        >
          {item}
        </li>
      ))}
    </ul>
  );
}
```

## 2.3 注意事项
- 绑定 DOM 的 ref 仅在组件挂载后才会有值（`current` 不为 null），挂载前访问会报错。
- 函数组件无法直接通过 ref 引用（需使用 `forwardRef` 转发 ref）。
- 避免通过 ref 直接修改 DOM 样式/内容，优先通过 state 控制（仅特殊场景使用）。

# 3. 场景2：存储持久化变量（跨渲染数据）
`useRef` 的另一个核心用途是存储“不需要触发渲染的持久化数据”，例如：
- 定时器 ID（用于组件卸载时清除）。
- 上一次的状态/属性值（用于对比变化）。
- 复杂计算的中间结果（无需响应式）。

## 3.1 示例1：存储定时器 ID
```jsx
import { useRef, useEffect, useState } from ''react'';

function Timer() {
  const [count, setCount] = useState(0);
  // 存储定时器 ID，跨渲染保留
  const timerRef = useRef(null);

  const startTimer = () => {
    // 启动定时器，将 ID 存入 ref
    timerRef.current = setInterval(() => {
      setCount(prev => prev + 1);
    }, 1000);
  };

  const stopTimer = () => {
    // 从 ref 中获取定时器 ID 并清除
    clearInterval(timerRef.current);
  };

  useEffect(() => {
    // 组件卸载时清除定时器
    return () => clearInterval(timerRef.current);
  }, []);

  return (
    <div>
      <p>计数：{count}</p>
      <button onClick={startTimer}>启动</button>
      <button onClick={stopTimer}>停止</button>
    </div>
  );
}
```

## 3.2 示例2：存储上一次的状态值
```jsx
import { useRef, useEffect, useState } from ''react'';

function PreviousState() {
  const [count, setCount] = useState(0);
  // 存储上一次的 count 值
  const prevCountRef = useRef(0);

  useEffect(() => {
    // 每次 count 变化后，更新 ref 中的值
    prevCountRef.current = count;
  }, [count]);

  return (
    <div>
      <p>当前值：{count}</p>
      <p>上一次值：{prevCountRef.current}</p>
      <button onClick={() => setCount(prev => prev + 1)}>+1</button>
    </div>
  );
}
```

## 3.3 与 useState 的区别
| 特性         | useRef                          | useState                        |
|--------------|---------------------------------|---------------------------------|
| 响应式       | 非响应式，修改不触发渲染        | 响应式，修改触发渲染            |
| 持久化       | 组件生命周期内持久不变          | 每次渲染返回当前值              |
| 用途         | 存储非响应式数据、DOM 引用      | 存储响应式状态                  |
| 语法         | 直接修改 `ref.current`          | 必须通过更新函数修改            |

# 4. 场景3：解决 useEffect 闭包陷阱
在 `useEffect` 中，若依赖项数组为空，副作用函数会捕获初始渲染的状态值，后续状态更新后无法获取最新值（闭包陷阱），使用 `useRef` 可解决此问题。

## 4.1 闭包陷阱示例
```jsx
// 问题：定时器中始终获取初始 count 值（0）
function ClosureTrap() {
  const [count, setCount] = useState(0);

  useEffect(() => {
    const timer = setInterval(() => {
      console.log(''当前 count：'', count); // 始终输出 0
    }, 1000);
    return () => clearInterval(timer);
  }, []);

  return (
    <div>
      <p>count：{count}</p>
      <button onClick={() => setCount(prev => prev + 1)}>+1</button>
    </div>
  );
}
```

## 4.2 使用 useRef 解决
```jsx
function FixClosureTrap() {
  const [count, setCount] = useState(0);
  // 创建 ref 存储最新 count 值
  const countRef = useRef(count);

  // 每次 count 变化，更新 ref 的值（不触发渲染）
  useEffect(() => {
    countRef.current = count;
  }, [count]);

  useEffect(() => {
    const timer = setInterval(() => {
      // 从 ref 中获取最新 count 值
      console.log(''当前 count：'', countRef.current);
    }, 1000);
    return () => clearInterval(timer);
  }, []);

  return (
    <div>
      <p>count：{count}</p>
      <button onClick={() => setCount(prev => prev + 1)}>+1</button>
    </div>
  );
}
```

# 5. useRef 与 createRef 的区别
| 特性         | useRef                          | createRef                       |
|--------------|---------------------------------|---------------------------------|
| 作用域       | 组件内持久化（跨渲染保留）| 每次渲染创建新的 ref 对象       |
| 适用场景     | 函数组件（推荐）| 类组件                          |
| 性能         | 更优（仅初始化一次）| 每次渲染重建，性能较差          |

示例：`createRef` 每次渲染重建
```jsx
import { createRef, useState } from ''react'';

function CreateRefDemo() {
  const [count, setCount] = useState(0);
  // 每次渲染都会创建新的 ref 对象
  const ref = createRef();

  console.log(''ref 对象是否变化：'', ref); // 每次渲染都不同

  return (
    <div>
      <p>count：{count}</p>
      <button onClick={() => setCount(prev => prev + 1)}>+1</button>
    </div>
  );
}
```

# 6. 核心总结
1. **核心作用**：
   - 获取 DOM 元素引用，实现必要的 DOM 操作。
   - 存储持久化、非响应式数据，跨渲染保留值。
2. **关键特性**：
   - `ref.current` 是存储值的唯一属性，修改不触发渲染。
   - 组件生命周期内持久不变，不会因重新渲染重置。
3. **典型场景**：
   - DOM 操作（聚焦输入框、获取尺寸）。
   - 存储定时器 ID、上一次状态值。
   - 解决 useEffect 闭包陷阱。
4. **注意事项**：
   - 避免滥用 ref 操作 DOM，优先通过 state 控制 UI。
   - 函数组件需使用 `forwardRef` 转发 ref。
   - 区别于 `useState`（非响应式）和 `createRef`（非持久化）。', 'aac29662-babe-4c96-8f61-0a16830155d4', 'true', '2025-12-19 15:11:58.078139+00', '2025-12-22 02:18:09.730825+00'), ('81f30ac0-7ddc-4c96-a78c-f230bfe90c67', '国际化（react-i18next）', '# 1. 国际化核心概念
国际化（i18n）是指让应用支持多语言切换，核心需求包括：
- 文本翻译：界面文字、提示信息支持多语言；
- 日期/时间/数字格式化：适配不同地区的显示规则；
- 动态语言切换：无需刷新页面，实时切换语言；
- 占位符替换：支持动态内容（如「你好，{{name}}」）；
- 复数处理：不同语言的复数规则（如英语 one/many，中文无复数）。

react-i18next 是基于 i18next 的 React 国际化解决方案，相比传统方案（如 react-intl），优势在于：
- 轻量级、高性能；
- 支持前后端共享翻译资源；
- 丰富的插件生态（如本地化存储、自动检测语言）；
- 支持 Hook/高阶组件/组件三种使用方式。

# 2. 安装与基础配置
## 2.1 安装依赖
```bash
npm install i18next react-i18next # 核心依赖
npm install i18next-browser-languagedetector i18next-localstorage-cache # 可选插件（自动检测浏览器语言、本地化存储）
```

## 2.2 初始化 i18n（src/i18n/index.ts）
```typescript
import i18n from ''i18next'';
import { initReactI18next } from ''react-i18next'';
import LanguageDetector from ''i18next-browser-languagedetector'';
import Cache from ''i18next-localstorage-cache'';

// 翻译资源
const resources = {
  en: {
    translation: {
      "welcome": "Welcome to our app",
      "hello": "Hello, {{name}}",
      "count": {
        "one": "{{count}} item",
        "other": "{{count}} items"
      },
      "button": {
        "login": "Login",
        "logout": "Logout"
      }
    }
  },
  zh: {
    translation: {
      "welcome": "欢迎来到我们的应用",
      "hello": "你好，{{name}}",
      "count": {
        "one": "{{count}} 个项目",
        "other": "{{count}} 个项目"
      },
      "button": {
        "login": "登录",
        "logout": "退出登录"
      }
    }
  }
};

i18n
  // 集成 React 插件
  .use(initReactI18next)
  // 自动检测浏览器语言
  .use(LanguageDetector)
  // 缓存语言设置
  .use(Cache)
  // 初始化配置
  .init({
    resources,
    fallbackLng: ''zh'', // 默认语言
    debug: process.env.NODE_ENV === ''development'', // 开发环境开启调试
    interpolation: {
      escapeValue: false, // React 已默认转义，无需重复处理
    },
    detection: {
      // 检测语言的顺序（本地存储 > cookie > 浏览器语言 > 默认语言）
      order: [''localStorage'', ''cookie'', ''navigator''],
      caches: [''localStorage'', ''cookie''], // 缓存语言设置到本地存储和 cookie
    },
    cache: {
      enabled: true, // 启用缓存
    }
  });

export default i18n;
```

## 2.3 全局注入（src/main.tsx）
```typescript
import React from ''react'';
import ReactDOM from ''react-dom/client'';
import ''./i18n''; // 导入 i18n 配置
import App from ''./App'';

const root = ReactDOM.createRoot(document.getElementById(''root'')!);
root.render(<App />);
```

# 3. 核心使用方式
## 3.1 Hook 方式（推荐）
使用 `useTranslation` Hook 实现组件内国际化：
```tsx
import React from ''react'';
import { useTranslation } from ''react-i18next'';

const HomePage = () => {
  const { t, i18n } = useTranslation();

  // 切换语言
  const changeLanguage = (lng: ''en'' | ''zh'') => {
    i18n.changeLanguage(lng);
  };

  return (
    <div>
      <h1>{t(''welcome'')}</h1>
      <p>{t(''hello'', { name: ''张三'' })}</p>
      <p>{t(''count.one'', { count: 1 })}</p>
      <p>{t(''count.other'', { count: 5 })}</p>
      <button onClick={() => changeLanguage(''en'')}>English</button>
      <button onClick={() => changeLanguage(''zh'')}>中文</button>
      <button>{t(''button.login'')}</button>
    </div>
  );
};

export default HomePage;
```

## 3.2 组件方式
使用 `Trans` 组件支持富文本翻译（如包含 HTML 标签、React 组件）：
```tsx
import React from ''react'';
import { Trans } from ''react-i18next'';

const RichText = () => {
  return (
    <div>
      <Trans i18nKey="richText">
        请<a href="/terms">阅读用户协议</a>并确认，<strong>否则无法使用</strong>。
      </Trans>
    </div>
  );
};

// 翻译资源中配置：
// "richText": "请<a>{{0}}</a>并确认，<strong>{{1}}</strong>否则无法使用。"
```

## 3.3 高阶组件方式
```tsx
import React from ''react'';
import { withTranslation } from ''react-i18next'';

const LoginButton = ({ t }) => {
  return <button>{t(''button.login'')}</button>;
};

export default withTranslation()(LoginButton);
```

# 4. 高级功能
## 4.1 命名空间（Namespaces）
拆分翻译资源为多个命名空间（如公共翻译、用户模块翻译），按需加载：
```typescript
// 初始化时配置命名空间
i18n.init({
  ns: [''common'', ''user''], // 命名空间列表
  defaultNS: ''common'', // 默认命名空间
});

// 组件中指定命名空间
const { t } = useTranslation(''user''); // 使用 user 命名空间
t(''profile.name''); // 读取 user 命名空间的 profile.name

// 多命名空间
const { t } = useTranslation([''common'', ''user'']);
t(''common:welcome''); // 显式指定命名空间
```

## 4.2 动态加载翻译资源
避免一次性加载所有语言资源，提升首屏加载速度：
```typescript
// src/i18n/translations.ts
export const loadTranslations = (lng: string) => {
  return import(`./locales/${lng}/translation.json`);
};

// 初始化时配置
i18n
  .use(initReactI18next)
  .init({
    fallbackLng: ''zh'',
    interpolation: { escapeValue: false },
    // 动态加载资源
    backend: {
      loadPath: ''/locales/{{lng}}/{{ns}}.json'',
    },
  });

// 组件中按需加载
const { t, i18n } = useTranslation();
i18n.loadNamespaces(''cart'').then(() => {
  // 加载 cart 命名空间后使用
  console.log(t(''cart:total''));
});
```

## 4.3 日期/数字格式化
结合 `i18next-intl-fallback` 或 `date-fns` 实现本地化格式化：
```bash
npm install date-fns @formatjs/intl-localematcher
```

```typescript
import { formatDate, formatNumber } from ''date-fns'';
import { zhCN, enUS } from ''date-fns/locale'';

const formatters = {
  en: {
    date: (date) => formatDate(date, ''MM/dd/yyyy'', { locale: enUS }),
    number: (num) => formatNumber(num, { style: ''currency'', currency: ''USD'' }),
  },
  zh: {
    date: (date) => formatDate(date, ''yyyy年MM月dd日'', { locale: zhCN }),
    number: (num) => formatNumber(num, { style: ''currency'', currency: ''CNY'' }),
  },
};

// 组件中使用
const { i18n } = useTranslation();
const currentLocale = i18n.language;
console.log(formatters[currentLocale].date(new Date()));
console.log(formatters[currentLocale].number(100));
```

## 4.4 复数处理
适配不同语言的复数规则（i18next 内置复数处理）：
```json
// 翻译资源
{
  "items": {
    "zero": "没有项目",
    "one": "1 个项目",
    "two": "2 个项目",
    "few": "{{count}} 个项目",
    "many": "{{count}} 个项目",
    "other": "{{count}} 个项目"
  }
}
```

```tsx
const { t } = useTranslation();
t(''items'', { count: 0 }); // 没有项目
t(''items'', { count: 1 }); // 1 个项目
t(''items'', { count: 5 }); // 5 个项目
```

# 5. 最佳实践
## 5.1 翻译资源管理
- 按模块拆分翻译文件（如 `common.json`/`user.json`/`cart.json`）；
- 使用 JSON 格式存储翻译资源，便于团队协作和翻译工具导入；
- 翻译键名使用驼峰命名或点分隔（如 `button.login`/`user.profile.name`），避免重复。

## 5.2 避免硬编码
- 所有界面文本均通过 `t()` 函数获取，禁止硬编码；
- 动态内容使用占位符（如 `{{name}}`），避免拼接字符串。

## 5.3 语言切换优化
- 语言切换时，缓存当前语言到本地存储，下次打开自动恢复；
- 避免语言切换后页面跳转，使用 React 状态管理实现无刷新切换。

## 5.4 生产环境配置
- 关闭 `debug` 模式，减少日志输出；
- 压缩翻译资源文件，开启 Gzip 压缩；
- 按需加载翻译资源，提升首屏加载速度。

# 6. 常见问题解决
## 6.1 翻译键未找到（missingKey）
- 检查翻译资源中是否存在对应键名；
- 确认命名空间是否正确（默认使用 `common` 命名空间）；
- 开启 `debug` 模式，控制台查看缺失的键名和命名空间。

## 6.2 动态加载翻译资源失败
- 检查资源路径是否正确（如 `/locales/en/common.json`）；
- 确认服务器配置了静态资源访问权限；
- 使用 `i18n.loadNamespaces` 手动加载命名空间，捕获加载错误。

## 6.3 语言切换后组件未重新渲染
- 确保使用 `useTranslation` Hook 或 `Trans` 组件（自动监听语言变化）；
- 高阶组件方式需确保组件接收 `t` 函数作为 props；
- 手动监听语言变化：
  ```tsx
  const { i18n } = useTranslation();
  useEffect(() => {
    const handleLanguageChange = () => {
      // 语言变化后执行逻辑
    };
    i18n.on(''languageChanged'', handleLanguageChange);
    return () => {
      i18n.off(''languageChanged'', handleLanguageChange);
    };
  }, [i18n]);
  ```
', 'ac88594f-879e-410b-94ce-266d80cce0f4', 'true', '2025-12-22 03:22:17.246452+00', '2025-12-23 14:32:25.997148+00'), ('84b94df2-64a4-46af-ae9c-e8c5169837cc', 'TypeScript 集成 React', '# 1. TypeScript 与 React 集成基础
TypeScript 是 JavaScript 的超集，通过静态类型检查提升代码健壮性，与 React 集成的核心价值在于：
- 对组件 Props、状态、Hooks 进行类型约束，减少运行时错误；
- 编辑器智能提示，提升开发效率；
- 明确代码接口，降低团队协作成本。

## 1.1 初始化 TypeScript + React 项目
- **Vite 项目**：直接选择 `react-ts` 模板
  ```bash
  npm create vite@latest my-react-ts-project -- --template react-ts
  ```
- **Webpack 项目**：需安装 TypeScript 及相关类型依赖
  ```bash
  npm install -D typescript @types/react @types/react-dom ts-loader
  ```
  并创建 `tsconfig.json`（参考 8.1 中 Webpack 配置章节）。

## 1.2 核心类型依赖
React 项目中需安装的基础类型包：
- `@types/react`：React 核心类型定义；
- `@types/react-dom`：React DOM 相关类型定义；
- `@types/node`（可选）：Node.js 环境类型（如路径别名）；
- `@types/react-router-dom`（可选）：React Router 类型定义。

# 2. Props 类型定义
Props 是组件的输入参数，TypeScript 提供多种方式约束 Props 类型：

## 2.1 基础 Props 类型（interface/type）
使用 `interface` 或 `type` 定义 Props 结构：
```tsx
// 方式1：interface（推荐，支持扩展）
interface ButtonProps {
  text: string; // 必传属性
  onClick?: () => void; // 可选属性
  type?: ''primary'' | ''secondary''; // 联合类型（限定取值）
  size: number;
}

// 方式2：type（灵活，支持交叉类型）
type ButtonProps = {
  text: string;
  onClick?: () => void;
  type?: ''primary'' | ''secondary'';
  size: number;
};

const Button = (props: ButtonProps) => {
  const { text, onClick, type = ''primary'', size } = props;
  return (
    <button onClick={onClick} className={`btn btn-${type}`} style={{ fontSize: size }}>
      {text}
    </button>
  );
};
```

## 2.2 必传属性与默认值
- 必传属性：直接定义类型（如 `text: string`），未传递时 TypeScript 报错；
- 可选属性：添加 `?`（如 `onClick?: () => void`）；
- 默认值：通过 `defaultProps` 或解构赋值设置，TypeScript 会自动识别：
  ```tsx
  // 解构赋值设置默认值
  const Button = ({ text, type = ''primary'' }: ButtonProps) => { /* ... */ };

  // 或通过 defaultProps（类组件/函数组件均可）
  Button.defaultProps = {
    type: ''primary'',
  };
  ```

## 2.3 子组件（children）类型
`children` 是 React 组件的特殊 Props，需显式定义类型：
```tsx
interface CardProps {
  title: string;
  children: React.ReactNode; // 支持所有 React 可渲染节点（元素、文本、数组等）
}

const Card = ({ title, children }: CardProps) => {
  return (
    <div className="card">
      <h3>{title}</h3>
      <div className="card-content">{children}</div>
    </div>
  );
};

// 使用
<Card title="卡片标题">
  <p>卡片内容</p>
</Card>
```
`React.ReactNode` 是最通用的 children 类型，包含：
- `ReactElement`（组件/元素）；
- `string`/`number`（文本）；
- `null`/`undefined`；
- 数组（`ReactNode[]`）。

## 2.4 继承 Props 类型
通过 `extends` 扩展已有 Props 类型：
```tsx
interface BaseButtonProps {
  disabled?: boolean;
  className?: string;
}

interface PrimaryButtonProps extends BaseButtonProps {
  text: string;
  onClick: () => void;
}

const PrimaryButton = (props: PrimaryButtonProps) => { /* ... */ };
```

## 2.5 事件处理 Props 类型
React 事件有专属类型（如 `React.MouseEvent`），需匹配事件类型：
```tsx
interface InputProps {
  value: string;
  onChange: (e: React.ChangeEvent<HTMLInputElement>) => void; // 输入框变更事件
  onBlur: (e: React.FocusEvent<HTMLInputElement>) => void; // 失焦事件
}

const Input = ({ value, onChange, onBlur }: InputProps) => {
  return <input value={value} onChange={onChange} onBlur={onBlur} />;
};

// 使用
<Input 
  value={inputValue} 
  onChange={(e) => setInputValue(e.target.value)} 
  onBlur={(e) => console.log(''失焦'', e.target.value)} 
/>
```
常见 React 事件类型：
- `React.MouseEvent<HTMLElement>`：鼠标事件（点击、双击等）；
- `React.ChangeEvent<HTMLInputElement>`：输入框/选择框变更事件；
- `React.FormEvent<HTMLFormElement>`：表单提交事件；
- `React.KeyboardEvent<HTMLInputElement>`：键盘事件。

# 3. 状态（State）类型定义
React 状态分为类组件 `this.state` 和函数组件 `useState`，需明确状态类型：

## 3.1 函数组件 useState 类型
- **基础类型**：TypeScript 自动推导（推荐）
  ```tsx
  const [count, setCount] = useState(0); // 自动推导 count: number
  const [name, setName] = useState(''''); // 自动推导 name: string
  const [isShow, setIsShow] = useState(false); // 自动推导 isShow: boolean
  ```
- **复杂类型**：需显式指定类型（或通过初始值推导）
  ```tsx
  // 数组类型
  const [list, setList] = useState<string[]>([]); // 字符串数组
  setList([''a'', ''b'']); // 正确
  // setList([1, 2]); // 错误：类型不匹配

  // 对象类型
  interface User {
    id: number;
    name: string;
    age?: number;
  }
  const [user, setUser] = useState<User>({ id: 1, name: ''张三'' }); // 显式指定类型
  setUser({ id: 2, name: ''李四'', age: 20 }); // 正确
  ```
- **联合类型状态**：需显式指定
  ```tsx
  const [data, setData] = useState<string | number | null>(null);
  setData(''hello''); // 正确
  setData(123); // 正确
  setData(null); // 正确
  ```

## 3.2 类组件 state 类型
类组件需通过接口定义 state 类型：
```tsx
interface CounterState {
  count: number;
  message: string;
}

class Counter extends React.Component<{}, CounterState> {
  // 初始 state
  state: CounterState = {
    count: 0,
    message: ''Hello'',
  };

  increment = () => {
    this.setState({ count: this.state.count + 1 });
  };

  render() {
    return (
      <div>
        <p>{this.state.message}</p>
        <p>Count: {this.state.count}</p>
        <button onClick={this.increment}>+1</button>
      </div>
    );
  }
}
```

# 4. Hooks 类型定义
React 内置 Hooks 均有对应的类型约束，需正确指定类型以获得类型检查：

## 4.1 useState（已在 1.3 中说明）

## 4.2 useEffect/useLayoutEffect
无返回值（或返回清理函数），TypeScript 自动推导，无需显式类型：
```tsx
useEffect(() => {
  const timer = setInterval(() => {
    setCount(count + 1);
  }, 1000);
  // 清理函数
  return () => clearInterval(timer);
}, [count]);
```

## 4.3 useRef
`useRef` 有两种用途：DOM 引用 / 持久化变量，需区分类型：
- **DOM 引用**：指定元素类型，初始值为 `null`
  ```tsx
  const inputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    if (inputRef.current) {
      inputRef.current.focus(); // 类型安全：current 为 HTMLInputElement | null
    }
  }, []);

  return <input ref={inputRef} />;
  ```
- **持久化变量**：指定变量类型，初始值为任意值
  ```tsx
  const timerRef = useRef<NodeJS.Timeout | null>(null);

  const startTimer = () => {
    timerRef.current = setInterval(() => { /* ... */ }, 1000);
  };

  const stopTimer = () => {
    if (timerRef.current) {
      clearInterval(timerRef.current);
    }
  };
  ```

## 4.4 useContext
需先定义 Context 类型，通过 `createContext` 指定：
```tsx
// 定义 Context 类型
interface ThemeContextType {
  theme: ''light'' | ''dark'';
  toggleTheme: () => void;
}

// 创建 Context（指定默认值类型）
const ThemeContext = createContext<ThemeContextType>({
  theme: ''light'',
  toggleTheme: () => {},
});

// 提供 Context
const ThemeProvider = ({ children }: { children: React.ReactNode }) => {
  const [theme, setTheme] = useState<''light'' | ''dark''>(''light'');
  const toggleTheme = () => setTheme(theme === ''light'' ? ''dark'' : ''light'');

  return (
    <ThemeContext.Provider value={{ theme, toggleTheme }}>
      {children}
    </ThemeContext.Provider>
  );
};

// 使用 Context
const ThemedButton = () => {
  const { theme, toggleTheme } = useContext(ThemeContext);
  return (
    <button onClick={toggleTheme} className={`theme-${theme}`}>
      当前主题：{theme}
    </button>
  );
};
```

## 4.5 useReducer
需定义状态类型、动作类型，确保 reducer 函数类型安全：
```tsx
// 定义状态类型
interface TodoState {
  list: { id: number; text: string; done: boolean }[];
}

// 定义动作类型（联合类型）
type TodoAction = 
  | { type: ''ADD_TODO''; payload: string }
  | { type: ''TOGGLE_TODO''; payload: number }
  | { type: ''DELETE_TODO''; payload: number };

// 初始状态
const initialState: TodoState = {
  list: [],
};

// Reducer 函数（类型约束）
const todoReducer = (state: TodoState, action: TodoAction): TodoState => {
  switch (action.type) {
    case ''ADD_TODO'':
      return {
        ...state,
        list: [...state.list, { id: Date.now(), text: action.payload, done: false }],
      };
    case ''TOGGLE_TODO'':
      return {
        ...state,
        list: state.list.map(item => 
          item.id === action.payload ? { ...item, done: !item.done } : item
        ),
      };
    case ''DELETE_TODO'':
      return {
        ...state,
        list: state.list.filter(item => item.id !== action.payload),
      };
    default:
      return state;
  }
};

// 使用 useReducer
const TodoList = () => {
  const [state, dispatch] = useReducer(todoReducer, initialState);

  const addTodo = (text: string) => {
    dispatch({ type: ''ADD_TODO'', payload: text });
  };

  return (
    <div>
      <button onClick={() => addTodo(''新任务'')}>添加任务</button>
      <ul>
        {state.list.map(item => (
          <li key={item.id} onClick={() => dispatch({ type: ''TOGGLE_TODO'', payload: item.id })}>
            {item.text} {item.done ? ''✅'' : ''❌''}
            <button onClick={() => dispatch({ type: ''DELETE_TODO'', payload: item.id })}>删除</button>
          </li>
        ))}
      </ul>
    </div>
  );
};
```

## 4.6 自定义 Hooks 类型
自定义 Hooks 需明确返回值类型，TypeScript 可自动推导，复杂场景建议显式指定：
```tsx
// 自定义 Hooks：获取窗口尺寸
const useWindowSize = (): { width: number; height: number } => {
  const [size, setSize] = useState({
    width: typeof window !== ''undefined'' ? window.innerWidth : 0,
    height: typeof window !== ''undefined'' ? window.innerHeight : 0,
  });

  useEffect(() => {
    const handleResize = () => {
      setSize({ width: window.innerWidth, height: window.innerHeight });
    };
    window.addEventListener(''resize'', handleResize);
    return () => window.removeEventListener(''resize'', handleResize);
  }, []);

  return size;
};

// 使用
const { width, height } = useWindowSize(); // 类型安全：width/height 为 number
```

# 5. 类组件类型（可选）
类组件需指定 Props 和 State 类型，通过 `React.Component<Props, State>` 约束：
```tsx
interface UserCardProps {
  userId: number;
}

interface UserCardState {
  user: { name: string; age: number } | null;
  loading: boolean;
}

class UserCard extends React.Component<UserCardProps, UserCardState> {
  constructor(props: UserCardProps) {
    super(props);
    this.state = {
      user: null,
      loading: true,
    };
  }

  componentDidMount() {
    // 模拟接口请求
    setTimeout(() => {
      this.setState({
        user: { name: ''张三'', age: 20 },
        loading: false,
      });
    }, 1000);
  }

  render() {
    const { loading, user } = this.state;
    if (loading) return <div>加载中...</div>;
    return (
      <div>
        <h3>{user?.name}</h3>
        <p>年龄：{user?.age}</p>
      </div>
    );
  }
}
```...', 'f9e86587-de73-4459-b574-fbd8be79b7c1', 'true', '2025-12-22 03:19:59.415433+00', '2025-12-23 13:34:42.783481+00'), ('87bc8b9a-4779-4a94-83f0-6c6b0f07358f', '状态提升与组件通信最佳实践', '在 React 应用中，组件之间的状态共享和通信是核心需求。**状态提升**是 React 官方推荐的组件通信方案，核心思想是：将多个组件共享的状态提升到它们的**最近公共父组件**中管理，父组件通过 `props` 将状态和更新函数传递给子组件，实现多组件状态同步。

# 1. 状态提升的核心思想与适用场景
## 1.1 核心思想
React 是**单向数据流**，数据只能从父组件流向子组件。当多个子组件需要共享同一状态（如表单输入、开关状态、列表数据）时，若每个子组件都维护一份独立状态，会导致状态不一致、同步困难。

状态提升的解决思路：
1. 找到多个子组件的**最近公共父组件**。
2. 将共享状态**移动到公共父组件中管理**。
3. 父组件定义**状态更新函数**，并通过 `props` 传递给子组件。
4. 子组件调用父组件传递的更新函数，修改公共状态，实现多组件状态同步。

## 1.2 适用场景
- 多个子组件需要**共享同一状态**（如兄弟组件之间的状态同步）。
- 子组件需要**修改父组件的状态**（如表单组件传递输入值给父组件）。
- 跨层级组件通信（但层级过深时推荐使用 Context，而非多层状态提升）。

# 2. 状态提升实战：温度转换器案例
以“摄氏度 ↔ 华氏度”转换器为例，两个输入框（摄氏度输入框、华氏度输入框）共享同一温度状态，修改其中一个输入框的值，另一个会自动同步更新。

## 2.1 需求分析
- 两个子组件：`CelsiusInput`（摄氏度输入）、`FahrenheitInput`（华氏度输入）。
- 两个子组件共享同一温度状态，修改任意一个，另一个需实时转换。
- 转换公式：`华氏度 = 摄氏度 × 9/5 + 32`；`摄氏度 = (华氏度 - 32) × 5/9`。

## 2.2 实现步骤
### （1）定义公共父组件：`TemperatureCalculator`
父组件作为状态的管理者，负责：
- 维护共享状态 `temperature` 和 `scale`（当前温度单位：`c` 表示摄氏度，`f` 表示华氏度）。
- 定义状态更新函数 `handleTemperatureChange`。
- 通过 `props` 将状态和更新函数传递给两个子组件。

```jsx
import { useState } from ''react'';

// 温度转换工具函数
function toCelsius(fahrenheit) {
  return ((fahrenheit - 32) * 5) / 9;
}

function toFahrenheit(celsius) {
  return (celsius * 9) / 5 + 32;
}

// 格式化温度显示（保留一位小数）
function tryConvert(temperature, convert) {
  const input = parseFloat(temperature);
  if (Number.isNaN(input)) return '''';
  const output = convert(input);
  const rounded = Math.round(output * 10) / 10;
  return rounded.toString();
}

// 父组件：状态提升的核心
function TemperatureCalculator() {
  // 共享状态：temperature（温度值）、scale（温度单位）
  const [temperature, setTemperature] = useState('''');
  const [scale, setScale] = useState(''c'');

  // 状态更新函数：接收子组件传递的温度值和单位
  const handleTemperatureChange = (newTemperature, newScale) => {
    setTemperature(newTemperature);
    setScale(newScale);
  };

  // 根据当前单位计算对应温度
  const celsius = scale === ''f'' ? tryConvert(temperature, toCelsius) : temperature;
  const fahrenheit = scale === ''c'' ? tryConvert(temperature, toFahrenheit) : temperature;

  return (
    <div>
      <h2>温度转换器</h2>
      {/* 传递状态和更新函数给子组件 */}
      <CelsiusInput
        temperature={celsius}
        onTemperatureChange={(value) => handleTemperatureChange(value, ''c'')}
      />
      <FahrenheitInput
        temperature={fahrenheit}
        onTemperatureChange={(value) => handleTemperatureChange(value, ''f'')}
      />
    </div>
  );
}
```

### （2）定义子组件：`CelsiusInput` 和 `FahrenheitInput`
子组件是**受控组件**，自身不维护状态，仅接收父组件传递的 `temperature` 和 `onTemperatureChange`，并在输入变化时调用更新函数。

```jsx
// 子组件1：摄氏度输入框
function CelsiusInput({ temperature, onTemperatureChange }) {
  const handleChange = (e) => {
    // 调用父组件传递的更新函数，传递输入值
    onTemperatureChange(e.target.value);
  };

  return (
    <div>
      <label>摄氏度：</label>
      <input type="number" value={temperature} onChange={handleChange} placeholder="输入摄氏度" />
      <span> °C</span>
    </div>
  );
}

// 子组件2：华氏度输入框
function FahrenheitInput({ temperature, onTemperatureChange }) {
  const handleChange = (e) => {
    onTemperatureChange(e.target.value);
  };

  return (
    <div style={{ marginTop: ''10px'' }}>
      <label>华氏度：</label>
      <input type="number" value={temperature} onChange={handleChange} placeholder="输入华氏度" />
      <span> °F</span>
    </div>
  );
}
```

## 2.3 运行效果
- 修改摄氏度输入框的值，华氏度输入框会自动转换并显示对应值。
- 修改华氏度输入框的值，摄氏度输入框会自动转换并显示对应值。
- 所有状态由父组件统一管理，两个子组件保持状态同步。

# 3. 组件通信最佳实践
React 中不同关系的组件，通信方式不同，需根据组件层级和业务需求选择合适的方案。

## 3.1 父子组件通信（最常用）
| 通信方向 | 实现方式 | 适用场景 |
|----------|----------|----------|
| 父 → 子 | **props 传递** | 父组件向子组件传递数据、方法 |
| 子 → 父 | **回调函数传参** | 子组件向父组件传递数据（如表单输入、事件结果） |

**最佳实践**：
- 子组件尽量设计为**受控组件**，自身不维护状态，通过 `props` 接收数据和更新函数。
- 父组件传递的回调函数，函数组件用 `useCallback` 缓存，避免子组件不必要的重渲染。

```jsx
// 父组件：用 useCallback 缓存回调函数
import { useState, useCallback } from ''react'';

function Parent() {
  const [value, setValue] = useState('''');

  // 缓存回调函数，依赖项仅为 setValue
  const handleChildChange = useCallback((newValue) => {
    setValue(newValue);
  }, [setValue]);

  return <Child onValueChange={handleChildChange} value={value} />;
}
```

## 3.2 兄弟组件通信
兄弟组件没有直接的 props 传递通道，需通过**状态提升**实现通信：
1. 共享状态提升到兄弟组件的最近公共父组件。
2. 父组件通过 props 将状态和更新函数传递给所有兄弟组件。

**最佳实践**：
- 兄弟组件数量较多时，可封装专门的父组件管理状态，避免业务逻辑分散。
- 状态更新函数命名清晰，明确函数用途（如 `onTodoAdd`、`onTodoDelete`）。

## 3.3 跨层级组件通信（爷孙组件、深层组件）
有两种主流方案，需根据场景选择：

| 方案 | 实现方式 | 适用场景 | 优缺点 |
|------|----------|----------|--------|
| **多层状态提升** | 逐层通过 props 传递状态和更新函数 | 层级较浅（≤3 层）、状态仅少数组件使用 | 优点：简单直观，无需额外 API；缺点：层级过深时 props 透传，代码冗余 |
| **Context 上下文** | 通过 `createContext` 创建上下文，`Provider` 提供数据，`useContext` 消费数据 | 层级较深、全局共享状态（如主题、用户信息） | 优点：避免 props 透传，代码简洁；缺点：过度使用会导致组件耦合度升高 |

**最佳实践**：
- **优先使用 Context** 处理跨层级通信，尤其是全局共享状态。
- 拆分 Context：将不同类型的共享状态拆分为多个独立 Context（如 `ThemeContext`、`UserContext`），避免单个 Context 过大导致不必要的重渲染。

## 3.4 非关联组件通信（无公共父组件）
非关联组件指没有任何共同父组件的组件（如页面 A 和页面 B），通信方案如下：
1. **全局状态管理库**：如 Redux、MobX、Zustand，适用于大型应用的全局状态共享。
2. **浏览器存储**：如 `localStorage`/`sessionStorage`，适用于持久化数据的通信（如用户登录状态）。
3. **事件总线**：如 `mitt` 库，通过发布/订阅模式实现组件通信，适用于小型应用的临时通信。

**最佳实践**：
- 中大型应用优先使用**Zustand**（轻量、易用）或 Redux Toolkit（Redux 官方推荐）。
- 避免滥用事件总线，容易导致数据流混乱，难以维护。

# 4. 状态管理与通信的核心原则
1. **单一数据源**：
   - 共享状态尽量集中管理，避免多个组件维护同一状态的副本，导致状态不一致。
   - 全局状态优先放在顶层组件或专门的状态管理库中。

2. **单向数据流**：
   - 数据只能从父组件流向子组件，子组件通过回调函数修改父组件状态，禁止子组件直接修改 props。
   - 状态更新逻辑清晰，便于追踪数据流向和调试。

3. **最小状态原则**：
   - 只保留必要的状态，避免冗余状态。可以通过计算得到的数据（如温度转换结果），不要作为独立状态存储。
   - 示例：温度转换器中，只存储 `temperature` 和 `scale`，摄氏度和华氏度的值通过计算得到，无需单独存储。

4. **组件职责单一**：
   - 组件分为两类：**容器组件**（管理状态和业务逻辑）和**展示组件**（仅负责渲染 UI，无状态）。
   - 展示组件通过 props 接收数据和回调，可复用性更强。

# 5. 核心总结
1. **状态提升**是解决兄弟组件通信的核心方案，将共享状态提升到最近公共父组件管理。
2. **组件通信方案选型**：
   - 父子通信：props + 回调函数。
   - 兄弟通信：状态提升。
   - 跨层级通信：优先 Context，层级较浅时可用多层状态提升。
   - 非关联组件通信：全局状态管理库或浏览器存储。
3. **最佳实践**：
   - 子组件尽量设计为受控组件，遵循单一数据源原则。
   - 回调函数用 `useCallback` 缓存，优化性能。
   - 拆分 Context，避免过度耦合。
   - 遵循单向数据流，保持状态更新逻辑清晰。', 'e42a3397-52b2-470f-a87d-08e025ba6944', 'true', '2025-12-19 11:41:25.747809+00', '2025-12-19 11:41:25.747809+00'), ('8a465da6-06c8-44e3-b277-b2e34debb0bb', 'React 开发环境搭建', '搭建 React 开发环境需先安装 Node.js（运行 JavaScript 的服务器环境），再选择合适的脚手架工具（Create React App 或 Vite）快速创建项目。

# 1. 前置准备：安装 Node.js
- 下载地址：[Node.js 官网](https://nodejs.org/)（推荐安装 LTS 长期支持版，自带 npm 包管理器）。
- 验证安装：安装完成后，打开终端（Windows 命令提示符/ PowerShell，Mac 终端），输入以下命令，显示版本号即安装成功：
  ```bash
  node -v  # 查看 Node.js 版本
  npm -v   # 查看 npm 版本
  ```

# 2. 方案一：Create React App（官方推荐，零配置）
Create React App（CRA）是 React 官方提供的脚手架工具，无需手动配置 Webpack、Babel 等构建工具，开箱即用，适合初学者。

## 2.1 创建项目
1. 打开终端，进入需创建项目的目录（如 `cd Desktop/ReactProjects`）。
2. 执行创建命令（项目名建议英文，如 `react-demo`）：
   ```bash
   npx create-react-app react-demo  # npx 可直接使用 npm 包，无需全局安装
   ```
   或全局安装 CRA 后创建（可选）：
   ```bash
   npm install -g create-react-app  # 全局安装
   create-react-app react-demo      # 创建项目
   ```
3. 等待依赖安装完成（需联网，时间根据网络情况而定）。

## 2.2 启动项目
1. 进入项目目录：
   ```bash
   cd react-demo
   ```
2. 启动开发服务器：
   ```bash
   npm start  # 或 yarn start（若安装了 yarn）
   ```
3. 启动成功后，终端会显示访问地址（默认 `http://localhost:3000`），打开浏览器即可看到 React 默认首页（带有 React 标志的页面）。

# 3. 方案二：Vite（快速构建，开发体验更优）
Vite 是新一代前端构建工具，相比 CRA 启动速度更快（基于 ES 模块原生支持，无需打包），热更新更高效，适合追求开发效率的场景。

## 3.1 创建项目
1. 终端进入目标目录，执行创建命令：
   ```bash
   npm create vite@latest  # 启动 Vite 项目创建向导
   ```
2. 按提示配置：
   - 输入项目名（如 `react-vite-demo`）。
   - 选择框架：上下箭头选择 `React`。
   - 选择变体：`React`（默认，使用 JavaScript）或 `React + TypeScript`（支持 TS 类型检查）。
3. 进入项目目录并安装依赖：
   ```bash
   cd react-vite-demo
   npm install  # 安装项目依赖
   ```

## 3.2 启动项目
执行启动命令：
```bash
npm run dev
```
启动成功后，终端会显示访问地址（默认 `http://127.0.0.1:5173/`），打开浏览器即可看到 Vite + React 的默认页面。

# 4. 两种方案对比
| 特性                | Create React App       | Vite                   |
|---------------------|------------------------|------------------------|
| 启动速度            | 较慢（需打包所有文件） | 极快（原生 ES 模块）   |
| 热更新效率          | 一般                   | 极快（只更新变化模块） |
| 配置复杂度          | 零配置（隐藏构建细节） | 简洁配置（支持自定义） |
| 适用场景            | 初学者、快速原型       | 生产项目、追求效率     |
', '885129c3-bae4-445c-979c-09863b3895f8', 'true', '2025-12-19 06:46:58.983421+00', '2025-12-19 09:05:09.477681+00'), ('90d6c87b-d397-4053-8788-3da07c5d1ed0', 'Redux 中间件', 'Redux 原生 Reducer 是纯函数，**无法处理异步操作**（如 API 请求、定时器）——中间件（Middleware）是 Redux 的扩展机制，用于在 Action 被 dispatch 后、到达 Reducer 前，插入自定义逻辑（如异步请求、日志打印、错误捕获）。

# 1. 中间件核心作用
- 拦截 Action，实现自定义处理逻辑；
- 支持异步 Action（如先请求 API，再 dispatch 同步 Action 更新状态）；
- 扩展 Redux 功能（如日志、持久化、撤销/重做）。

# 2. Redux-Thunk：轻量级异步解决方案
`redux-thunk` 是最常用的 Redux 中间件，允许 Action 创建函数返回**函数**（而非普通对象），该函数接收 `dispatch` 和 `getState` 作为参数，可在内部执行异步操作，完成后 dispatch 同步 Action 更新状态。

## 2.1 核心特性
- 轻量（无额外依赖）、易用；
- 适合简单异步场景（如单次 API 请求）；
- Redux Toolkit 已内置 `redux-thunk`，无需手动安装。

## 2.2 实现异步逻辑：创建 Thunk Action
Thunk Action 是返回函数的 Action 创建函数，内部可执行异步操作：

```javascript
import { createSlice, createAsyncThunk } from ''@reduxjs/toolkit'';
import axios from ''axios'';

// 方式1：手动创建 Thunk Action（基础用法）
export const fetchTodos = () => {
  // 返回函数，接收 dispatch 和 getState
  return async (dispatch, getState) => {
    try {
      // 1. 发送加载中 Action（更新加载状态）
      dispatch(setLoading(true));

      // 2. 异步请求 API
      const res = await axios.get(''https://jsonplaceholder.typicode.com/todos'');

      // 3. 请求成功，dispatch 同步 Action 更新状态
      dispatch(loadTodos(res.data));
    } catch (err) {
      // 4. 请求失败，dispatch 错误 Action
      dispatch(setError(err.message));
    } finally {
      // 5. 结束加载
      dispatch(setLoading(false));
    }
  };
};

// 方式2：RTK 内置 createAsyncThunk（推荐，自动生成 pending/fulfilled/rejected Action）
export const fetchTodosAsync = createAsyncThunk(
  ''todo/fetchTodos'', // Action 类型前缀
  async (_, { rejectWithValue }) => {
    try {
      const res = await axios.get(''https://jsonplaceholder.typicode.com/todos'');
      return res.data; // 成功时，结果会作为 payload 传入 fulfilled Action
    } catch (err) {
      // 失败时，返回错误信息（通过 rejectWithValue 传递）
      return rejectWithValue(err.message);
    }
  }
);

// Todo Slice 中处理异步 Action
const todoSlice = createSlice({
  name: ''todo'',
  initialState: {
    todos: [],
    loading: false,
    error: null
  },
  reducers: {
    // 同步 Action 处理
    setLoading: (state, action) => {
      state.loading = action.payload;
    }
  },
  // 处理 createAsyncThunk 生成的异步 Action
  extraReducers: (builder) => {
    builder
      // 请求中（pending）
      .addCase(fetchTodosAsync.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      // 请求成功（fulfilled）
      .addCase(fetchTodosAsync.fulfilled, (state, action) => {
        state.loading = false;
        state.todos = action.payload; // payload 为 API 返回数据
      })
      // 请求失败（rejected）
      .addCase(fetchTodosAsync.rejected, (state, action) => {
        state.loading = false;
        state.error = action.payload; // payload 为 rejectWithValue 传递的错误信息
      });
  }
});

export const { setLoading } = todoSlice.actions;
export default todoSlice.reducer;
```

## 2.3 组件中调用 Thunk Action
```javascript
import { useEffect } from ''react'';
import { useDispatch, useSelector } from ''react-redux'';
import { fetchTodosAsync } from ''./features/todo/todoSlice'';

function TodoList() {
  const dispatch = useDispatch();
  const { todos, loading, error } = useSelector((state) => state.todos);

  // 组件挂载时触发异步请求
  useEffect(() => {
    dispatch(fetchTodosAsync());
  }, [dispatch]);

  if (loading) return <div>加载中...</div>;
  if (error) return <div>错误：{error}</div>;

  return (
    <ul>
      {todos.map((todo) => (
        <li key={todo.id}>{todo.title}</li>
      ))}
    </ul>
  );
}
```

# 3. Redux-Saga：复杂异步流程管理
`redux-saga` 是基于**生成器（Generator）** 的 Redux 中间件，专注于处理复杂异步流程（如并发请求、取消请求、轮询、依赖请求），通过“监听 Action”的方式触发异步逻辑，代码可读性和可维护性更高。

## 3.1 核心特性
- 支持 Generator 函数，用同步写法处理异步逻辑；
- 提供丰富的 Effect 函数（如 `call`、`put`、`takeEvery`、`fork`），处理异步操作；
- 支持取消异步任务、错误捕获、并发控制；
- 适合复杂异步场景（如电商下单流程、实时数据同步）。

## 3.2 快速上手：安装与配置
```bash
npm install redux-saga

yarn add redux-saga
```

配置 Store（需手动添加 saga 中间件）：
```javascript
import { configureStore } from ''@reduxjs/toolkit'';
import createSagaMiddleware from ''redux-saga'';
import todoReducer from ''./features/todo/todoSlice'';
import rootSaga from ''./sagas'';

// 创建 saga 中间件
const sagaMiddleware = createSagaMiddleware();

// 配置 Store，添加 saga 中间件
const store = configureStore({
  reducer: {
    todos: todoReducer
  },
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware().concat(sagaMiddleware) // 加入 saga 中间件
});

// 运行根 saga
sagaMiddleware.run(rootSaga);

export default store;
```

## 3.3 核心 Effect 函数
| Effect 函数 | 作用 |
|-------------|------|
| `call(fn, ...args)` | 调用异步函数（如 API 请求），阻塞等待结果 |
| `put(action)` | 触发 Action（相当于 dispatch） |
| `takeEvery(actionType, saga)` | 监听指定 Action，每次触发都执行 saga（支持并发） |
| `takeLatest(actionType, saga)` | 监听指定 Action，只执行最后一次触发的 saga（取消之前未完成的任务） |
| `fork(fn, ...args)` | 非阻塞调用函数（不等待结果，适合后台任务） |
| `cancel(task)` | 取消 fork 创建的异步任务 |

## 3.4 实现异步逻辑：创建 Saga
```javascript
// src/sagas/todoSaga.js
import { call, put, takeLatest } from ''redux-saga/effects'';
import axios from ''axios'';
import { fetchTodosSuccess, fetchTodosFailure, setLoading } from ''../features/todo/todoSlice'';

// 定义异步请求函数
const fetchTodosApi = async () => {
  const res = await axios.get(''https://jsonplaceholder.typicode.com/todos'');
  return res.data;
};

// 定义 Saga 生成器函数（处理异步逻辑）
function* fetchTodosSaga() {
  try {
    // 触发加载中 Action
    yield put(setLoading(true));

    // 调用 API（阻塞等待结果）
    const data = yield call(fetchTodosApi);

    // 请求成功，触发成功 Action
    yield put(fetchTodosSuccess(data));
  } catch (err) {
    // 请求失败，触发失败 Action
    yield put(fetchTodosFailure(err.message));
  } finally {
    // 结束加载
    yield put(setLoading(false));
  }
}

// 监听 Action：当 dispatch(fetchTodosRequest()) 时，执行 fetchTodosSaga
export function* watchFetchTodos() {
  // takeLatest：只处理最后一次请求（避免重复请求）
  yield takeLatest(''todo/fetchTodosRequest'', fetchTodosSaga);
}
```

## 3.5 根 Saga（组合多个 Saga）
```javascript
// src/sagas/index.js（rootSaga）
import { all } from ''redux-saga/effects'';
import { watchFetchTodos } from ''./todoSaga'';
import { watchFetchUser } from ''./userSaga'';

// 根 Saga：合并所有子 Saga
export default function* rootSaga() {
  yield all([
    watchFetchTodos(),
    watchFetchUser()
  ]);
}
```

## 3.6 组件中触发 Saga 监听的 Action
```javascript
// src/features/todo/todoSlice.js（定义触发 Saga 的 Action）
import { createSlice } from ''@reduxjs/toolkit'';

const todoSlice = createSlice({
  name: ''todo'',
  initialState: {
    todos: [],
    loading: false,
    error: null
  },
  reducers: {
    fetchTodosRequest: (state) => {}, // 仅用于触发 Saga，无状态修改
    fetchTodosSuccess: (state, action) => {
      state.todos = action.payload;
    },
    fetchTodosFailure: (state, action) => {
      state.error = action.payload;
    },
    setLoading: (state, action) => {
      state.loading = action.payload;
    }
  }
});

export const { fetchTodosRequest, fetchTodosSuccess, fetchTodosFailure, setLoading } = todoSlice.actions;
export default todoSlice.reducer;
```

```javascript
// 组件中触发 Action
import { useEffect } from ''react'';
import { useDispatch, useSelector } from ''react-redux'';
import { fetchTodosRequest } from ''./features/todo/todoSlice'';

function TodoList() {
  const dispatch = useDispatch();
  const { todos, loading, error } = useSelector((state) => state.todos);

  useEffect(() => {
    // 触发 fetchTodosRequest Action，Saga 监听到后执行异步逻辑
    dispatch(fetchTodosRequest());
  }, [dispatch]);

  // 渲染逻辑...
}
```

# 4. Redux-Thunk vs Redux-Saga 对比
| 特性                | Redux-Thunk                | Redux-Saga                  |
|---------------------|----------------------------|-----------------------------|
| 语法                | 普通函数 + Promise          | Generator 函数 + Effect      |
| 学习成本            | 低（无需学习新概念）| 高（需理解 Generator/Effect）|
| 异步流程控制        | 简单（适合单次请求）| 强大（支持并发、取消、轮询）|
| 错误处理            | try/catch 包裹异步代码      | try/catch 包裹 Effect 函数   |
| 可读性              | 中等（嵌套 Promise 易混乱） | 高（同步写法，流程清晰）|
| 适用场景            | 简单异步需求（如列表请求）| 复杂异步需求（如订单流程）|
', 'a3109983-f66b-42c0-afb5-8d07e97cbc4e', 'true', '2025-12-22 03:13:23.512805+00', '2025-12-23 08:40:19.202808+00'), ('91045cc1-a8c8-46b4-8d8a-c3209736ae60', '路由参数', '在单页应用中，路由参数是传递数据的重要方式，React Router v6 支持两种核心参数类型：**动态路由参数**（URL 路径中的参数，如 `/user/:id`）和**搜索参数**（URL 中 `?` 后的参数，如 `/list?page=1&size=10`）。对应的，提供了 `useParams` 和 `useSearchParams` 两个钩子函数用于获取和操作这些参数，以下是详细解析：

# 1. 动态路由参数（路径参数）
动态路由参数是嵌入在路由路径中的变量，用于匹配一类路径（如 `/user/123`、`/user/456` 可匹配同一个路由规则），参数名以 `:` 开头，是实现“详情页”“个性化页面”的核心方式。

## 1.1 定义动态路由
在 `Route` 组件的 `path` 属性中，通过 `:参数名` 定义动态参数：
```jsx
import { Routes, Route } from ''react-router-dom'';
import UserDetail from ''./pages/UserDetail'';
import ArticleDetail from ''./pages/ArticleDetail'';

function App() {
  return (
    <Routes>
      {/* 定义动态参数 id：匹配 /user/123、/user/456 等路径 */}
      <Route path="/user/:id" element={<UserDetail />} />
      
      {/* 支持多个动态参数：匹配 /article/2024/10 */}
      <Route path="/article/:year/:month" element={<ArticleDetail />} />
      
      {/* 可选动态参数（加 ?）：匹配 /tag 或 /tag/react */}
      <Route path="/tag/:name?" element={<TagPage />} />
    </Routes>
  );
}
```

## 1.2 useParams：获取动态路由参数
`useParams` 是 React Router v6 提供的钩子函数，用于在路由组件中获取动态路由参数，返回一个对象，键为参数名，值为 URL 中对应的参数值（字符串类型）。

### 1.2.1 基本用法
```jsx
// UserDetail.js（路由组件）
import { useParams } from ''react-router-dom'';

function UserDetail() {
  // 获取动态参数：params 为 { id: "123" }（若 URL 为 /user/123）
  const params = useParams();
  
  // 注意：参数值默认是字符串，需根据需求转换为数字/布尔值
  const userId = Number(params.id);

  return (
    <div>
      <h1>用户详情页</h1>
      <p>用户 ID：{userId}</p>
      <p>参数原始类型：{typeof params.id}</p> {/* 输出 string */}
    </div>
  );
}

export default UserDetail;
```

### 1.2.2 多个动态参数示例
```jsx
// ArticleDetail.js
import { useParams } from ''react-router-dom'';

function ArticleDetail() {
  // URL 为 /article/2024/10 时，params 为 { year: "2024", month: "10" }
  const { year, month } = useParams();

  return (
    <div>
      <h1>2024年10月文章列表</h1>
      <p>年份：{year}（类型：{typeof year}）</p>
      <p>月份：{month}（类型：{typeof month}）</p>
    </div>
  );
}
```

### 1.2.3 可选动态参数示例
```jsx
// TagPage.js
import { useParams } from ''react-router-dom'';

function TagPage() {
  // URL 为 /tag 时，params 为 {} → name 为 undefined
  // URL 为 /tag/react 时，params 为 { name: "react" }
  const { name } = useParams();

  return (
    <div>
      <h1>{name ? `标签：${name}` : ''所有标签''}</h1>
    </div>
  );
}
```

## 1.3 动态路由参数的注意事项
- 参数值默认是**字符串类型**，若需数字、布尔值等类型，需手动转换（如 `Number(params.id)`）；
- 动态参数不能包含 `/` 字符（URL 中 `/` 用于分隔路径），若需传递包含 `/` 的数据，需使用搜索参数；
- 可选参数需在参数名后加 `?`（如 `:name?`），否则 URL 中缺少该参数时会匹配失败（跳转到 404 页面）；
- 路由匹配优先级：静态路由（如 `/user/profile`）优先级高于动态路由（如 `/user/:id`），需将静态路由放在动态路由之前定义。

# 2. 搜索参数（Query 参数）
搜索参数是 URL 中 `?` 后面的键值对（如 `/list?page=1&size=10&keyword=react`），用于传递非核心数据（如分页信息、筛选条件、搜索关键词），支持多个参数拼接（用 `&` 分隔），参数顺序不影响匹配。

## 2.1 定义与跳转时传递搜索参数
搜索参数无需在路由规则中预先定义，可通过 `Link`、`NavLink` 或 `useNavigate` 跳转时直接拼接在 URL 后：

### 方式1：通过 Link/NavLink 传递
```jsx
import { Link } from ''react-router-dom'';

function ProductList() {
  return (
    <div>
      {/* 直接拼接搜索参数 */}
      <Link to="/list?page=1&size=10&keyword=手机">手机列表（第1页）</Link>
      
      {/* 通过对象形式传递（更优雅） */}
      <Link
        to={{
          pathname: ''/list'',
          search: ''page=2&size=10&keyword=电脑''
        }}
      >
        电脑列表（第2页）
      </Link>
    </div>
  );
}
```

### 方式2：通过 useNavigate 传递（编程式）
```jsx
import { useNavigate } from ''react-router-dom'';

function SearchBar() {
  const navigate = useNavigate();
  const keyword = ''react'';

  const handleSearch = () => {
    // 方式1：直接拼接
    navigate(`/search?keyword=${keyword}&page=1`);
    
    // 方式2：使用 URLSearchParams 拼接（自动处理特殊字符）
    const params = new URLSearchParams();
    params.append(''keyword'', keyword);
    params.append(''page'', ''1'');
    params.append(''size'', ''10'');
    navigate(`/search?${params}`); // 结果：/search?keyword=react&page=1&size=10
  };

  return <button onClick={handleSearch}>搜索</button>;
}
```

## 2.2 useSearchParams：获取与操作搜索参数
`useSearchParams` 是 React Router v6 新增的核心钩子，用于在路由组件中**获取、修改、删除**搜索参数，返回一个数组：`[searchParams, setSearchParams]`，其中：
- `searchParams`：`URLSearchParams` 实例，提供 `get`、`getAll` 等方法获取参数；
- `setSearchParams`：函数，用于修改搜索参数（会触发路由更新）。

### 2.2.1 核心方法（searchParams）
| 方法名      | 说明                                                                 |
|-------------|----------------------------------------------------------------------|
| `get(key)`  | 获取单个参数值（若有多个同名参数，返回第一个），不存在返回 `null`     |
| `getAll(key)`| 获取多个同名参数值（返回数组），不存在返回空数组                     |
| `has(key)`  | 判断参数是否存在（返回布尔值）                                       |
| `keys()`    | 获取所有参数名（返回迭代器）                                         |
| `entries()` | 获取所有参数的键值对（返回迭代器）                                   |

### 2.2.2 基本用法：获取搜索参数
```jsx
// ListPage.js（路由组件，URL 为 /list?page=1&size=10&keyword=手机）
import { useSearchParams } from ''react-router-dom'';

function ListPage() {
  // 初始化：searchParams 是 URLSearchParams 实例，setSearchParams 用于修改参数
  const [searchParams, setSearchParams] = useSearchParams();

  // 1. 获取单个参数（默认字符串类型，需手动转换）
  const page = Number(searchParams.get(''page'')) || 1; // 若不存在，默认1
  const size = Number(searchParams.get(''size'')) || 10;
  const keyword = searchParams.get(''keyword'') || ''全部'';

  // 2. 获取多个同名参数（如 /list?tag=react&tag=vue）
  const tags = searchParams.getAll(''tag''); // 返回 ["react", "vue"]

  // 3. 判断参数是否存在
  const hasFilter = searchParams.has(''filter''); // 返回 true/false

  return (
    <div>
      <h1>商品列表</h1>
      <p>关键词：{keyword}</p>
      <p>当前页：{page}，每页条数：{size}</p>
      <p>标签：{tags.join('', '')}</p>
    </div>
  );
}
```

### 2.2.3 进阶用法：修改搜索参数
`setSearchParams` 函数用于修改搜索参数，支持两种传入形式：对象或 `URLSearchParams` 实例，修改后会触发路由更新（组件重新渲染）。

```jsx
function ListPage() {
  const [searchParams, setSearchParams] = useSearchParams();

  // 1. 跳转到下一页（保留其他参数，仅修改 page）
  const goToNextPage = () => {
    const currentPage = Number(searchParams.get(''page'')) || 1;
    // 传入对象：会合并现有参数（同名参数会覆盖）
    setSearchParams({
      ...Object.fromEntries(searchParams.entries()), // 保留现有所有参数
      page: currentPage + 1 // 修改 page 参数
    });
  };

  // 2. 筛选标签（添加 tag 参数）
  const addTag = (tag) => {
    const newParams = new URLSearchParams(searchParams);
    newParams.append(''tag'', tag); // 添加同名参数（支持多个标签）
    setSearchParams(newParams);
  };

  // 3. 重置筛选条件（清空所有搜索参数）
  const resetFilters = () => {
    setSearchParams({}); // 传入空对象，清空所有参数
  };

  return (
    <div>
      <button onClick={goToNextPage}>下一页</button>
      <button onClick={() => addTag(''react'')}>添加标签：react</button>
      <button onClick={resetFilters}>重置筛选</button>
    </div>
  );
}
```

## 2.3 搜索参数的注意事项
- 搜索参数值默认是**字符串类型**，且会自动编码特殊字符（如空格、中文 → `%20`、`%E4%B8%AD%E6%96%87`），无需手动处理；
- `setSearchParams` 会默认使用 `push` 模式（添加新历史记录），若需替换历史记录，可传入第二个参数 `{ replace: true }`：
  ```jsx
  setSearchParams({ page: 2 }, { replace: true });
  ```
- 搜索参数可动态添加、删除，无需修改路由规则，适合传递临时、非核心数据（如分页、筛选条件）；
- 刷新页面后，搜索参数会保留在 URL 中（优于动态路由参数的 `state`），适合需要持久化的临时数据。

# 3. 动态路由参数 vs 搜索参数：对比与场景选择
| 特性                | 动态路由参数（/user/:id）                | 搜索参数（/list?page=1）                  |
|---------------------|-------------------------------------------|-------------------------------------------|
| URL 形式            | 路径内嵌，简洁直观（如 /user/123）        | 路径后拼接，显式键值对（如 /list?page=1） |
| 核心用途            | 标识资源唯一性（如用户 ID、文章 ID）      | 传递临时/筛选数据（分页、搜索关键词）      |
| 必传性              | 默认必传（可选需加 ?），否则路由不匹配    | 可选，不存在不影响路由匹配                |
| 数据类型            | 仅支持字符串，需手动转换其他类型          | 仅支持字符串，自动编码特殊字符            |
| 刷新页面保留        | 是（URL 可见）                            | 是（URL 可见）                            |
| 多个同名参数        | 不支持（路径中无法重复同名参数）          | 支持（通过 getAll 方法获取数组）          |

## 3.1 场景选择建议
- 若参数是资源的唯一标识（如用户 ID、商品 ID、文章 ID），使用**动态路由参数**（如 `/user/:id`）；
- 若参数是临时筛选条件（如分页、搜索关键词、标签筛选），使用**搜索参数**（如 `/list?page=1&keyword=react`）；
- 若参数可选且不影响路由匹配，使用**搜索参数**或**可选动态参数**（如 `/tag/:name?`）；
- 若需要传递多个同名参数（如多个标签），只能使用**搜索参数**。

# 4. 常见问题与解决方案
1. **动态参数类型转换错误**：参数默认是字符串，若需数字类型，需用 `Number()` 转换，同时处理 `null` 情况（如 `Number(params.id) || 0`）；
2. **搜索参数中文乱码**：`URLSearchParams` 会自动编码/解码中文，无需手动处理，直接通过 `get` 方法获取即可；
3. **修改搜索参数后组件不更新**：`useSearchParams` 会监听参数变化并触发组件重渲染，若未更新，检查是否遗漏参数依赖（如 `useEffect` 中需依赖 `searchParams`）；
4. **可选动态参数匹配失败**：确保参数名后加 `?`（如 `/tag/:name?`），否则 URL 中缺少该参数时会匹配 404 页面。

# 5. 实战示例：结合两种参数实现详情页+筛选
```jsx
// 路由规则定义
<Route path="/product/:id" element={<ProductDetail />} />

// ProductDetail.js（URL 为 /product/123?color=red&size=M）
import { useParams, useSearchParams } from ''react-router-dom'';

function ProductDetail() {
  // 获取动态参数（商品 ID）
  const { id } = useParams();
  const productId = Number(id);

  // 获取搜索参数（筛选条件）
  const [searchParams] = useSearchParams();
  const color = searchParams.get(''color'');
  const size = searchParams.get(''size'');

  // 模拟请求商品详情（结合 ID 和筛选条件）
  useEffect(() => {
    fetch(`/api/product/${productId}?color=${color}&size=${size}`)
      .then(res => res.json())
      .then(data => setProduct(data));
  }, [productId, color, size]); // 依赖参数变化，重新请求数据

  return (
    <div>
      <h1>商品 ID：{productId}</h1>
      <p>筛选条件：颜色={color || ''默认''}，尺寸={size || ''默认''}</p>
      {/* 商品详情内容 */}
    </div>
  );
}
```...', 'aee449bc-0035-43a6-834d-3e6ce98b6aff', 'true', '2025-12-22 02:07:10.169563+00', '2025-12-23 02:43:09.516784+00'), ('94d4cf65-a0d7-4fb6-832a-a33781ae483f', 'useImperativeHandle：暴露组件方法', '# 1. 核心概念
在 React 中，组件间通信遵循“自上而下”的单向数据流（父组件通过 props 传递数据给子组件），默认情况下父组件无法直接调用子组件的方法或访问子组件的 DOM 元素。`useImperativeHandle` 是 React 提供的 Hook，用于**自定义子组件暴露给父组件的实例值**（通常是方法或 DOM 引用），配合 `ref` 实现父组件对子女件的“命令式”操作。

## 1.1 设计目的
- 替代直接传递 DOM ref（避免父组件过度访问子组件内部 DOM，破坏封装性）；
- 自定义暴露的方法/属性，仅开放必要的接口，增强组件封装性；
- 兼容函数组件（函数组件无实例，需通过 `forwardRef` + `useImperativeHandle` 实现 ref 传递）。

# 2. 基本用法
## 步骤1：子组件使用 `forwardRef` + `useImperativeHandle`
```javascript
import { forwardRef, useImperativeHandle, useRef } from ''react'';

// 子组件：通过 forwardRef 接收父组件传递的 ref
const ChildInput = forwardRef((props, ref) => {
  // 子组件内部的 DOM ref
  const inputRef = useRef(null);

  // 自定义暴露给父组件的方法/属性
  useImperativeHandle(ref, () => ({
    // 暴露聚焦方法
    focus: () => {
      inputRef.current.focus();
    },
    // 暴露清空方法
    clear: () => {
      inputRef.current.value = '''';
    },
    // 暴露获取值的方法
    getValue: () => {
      return inputRef.current.value;
    }
  }), []); // 依赖项为空：仅初始化一次暴露的对象

  return <input ref={inputRef} type="text" placeholder="请输入内容" />;
});

export default ChildInput;
```

## 步骤2：父组件通过 ref 调用子组件方法
```javascript
import { useRef } from ''react'';
import ChildInput from ''./ChildInput'';

function ParentComponent() {
  // 创建 ref 传递给子组件
  const childInputRef = useRef(null);

  const handleFocus = () => {
    // 调用子组件暴露的 focus 方法
    childInputRef.current?.focus();
  };

  const handleClear = () => {
    // 调用子组件暴露的 clear 方法
    childInputRef.current?.clear();
  };

  const handleGetValue = () => {
    // 调用子组件暴露的 getValue 方法
    const value = childInputRef.current?.getValue();
    alert(`输入框值：${value}`);
  };

  return (
    <div>
      <ChildInput ref={childInputRef} />
      <button onClick={handleFocus}>聚焦输入框</button>
      <button onClick={handleClear}>清空输入框</button>
      <button onClick={handleGetValue}>获取输入框值</button>
    </div>
  );
}
```

# 3. 关键细节
## 3.1 依赖项数组
`useImperativeHandle` 的第三个参数是依赖项数组，当依赖项变化时，会重新创建暴露的对象：
```javascript
useImperativeHandle(ref, () => ({
  // 依赖 inputValue，当 inputValue 变化时重新创建对象
  logValue: () => console.log(inputValue)
}), [inputValue]);
```

## 3.2 避免暴露过多内容
`useImperativeHandle` 的核心价值是**封装**，应仅暴露父组件必需的方法/属性，避免暴露整个 DOM 元素或子组件内部状态：
```javascript
// 不推荐：暴露整个 DOM 元素（破坏封装）
useImperativeHandle(ref, () => inputRef.current, []);

// 推荐：仅暴露必要方法
useImperativeHandle(ref, () => ({
  focus: () => inputRef.current.focus()
}), []);
```

## 3.3 与类组件的对比
类组件通过 `this.refs` 或传递 `ref` 可直接访问子组件实例，但函数组件需通过 `forwardRef` + `useImperativeHandle` 实现：
```javascript
// 类组件子组件
class ClassChildInput extends React.Component {
  focus() {
    this.inputRef.focus();
  }

  render() {
    return <input ref={el => this.inputRef = el} />;
  }
}

// 父组件调用
class Parent extends React.Component {
  childRef = React.createRef();

  handleFocus = () => {
    this.childRef.current.focus();
  };

  render() {
    return (
      <div>
        <ClassChildInput ref={this.childRef} />
        <button onClick={this.handleFocus}>聚焦</button>
      </div>
    );
  }
}
```

# 4. 适用场景
1. **表单组件交互**：父组件需要控制子组件表单元素（如聚焦输入框、清空文本域）；
2. **第三方组件封装**：封装第三方 UI 组件时，暴露自定义方法（如弹窗的打开/关闭）；
3. **动画控制**：父组件触发子组件内部的动画（如滚动到指定位置、播放动画）；
4. **避免 DOM 穿透**：子组件内部有多个 DOM 元素，父组件无需知道具体 DOM 结构，仅调用封装好的方法。

# 5. 注意事项
1. **尽量避免使用**：命令式操作违背 React 声明式编程理念，优先通过 props + 状态管理实现组件通信；
2. **空值保护**：调用子组件方法时需用 `?.` 保护（避免子组件未挂载时调用导致报错）；
3. **不要暴露状态**：优先通过 props 传递状态，而非让父组件直接访问子组件内部状态；
4. **配合 TypeScript 使用**：需定义 ref 类型，增强类型安全：
   ```typescript
   import { forwardRef, useImperativeHandle, useRef, Ref } from ''react'';

   // 定义暴露的方法类型
   interface ChildInputRef {
     focus: () => void;
     clear: () => void;
     getValue: () => string;
   }

   const ChildInput = forwardRef((props: {}, ref: Ref<ChildInputRef>) => {
     const inputRef = useRef<HTMLInputElement>(null);

     useImperativeHandle(ref, () => ({
       focus: () => inputRef.current?.focus(),
       clear: () => { if (inputRef.current) inputRef.current.value = ''''; },
       getValue: () => inputRef.current?.value || ''''
     }), []);

     return <input ref={inputRef} />;
   });

   // 父组件中使用
   const childInputRef = useRef<ChildInputRef>(null);
   ```', '0fa74abf-556e-40ef-a0d4-33dc2f8648a5', 'true', '2025-12-22 03:17:42.652525+00', '2025-12-23 09:58:31.326745+00'), ('9588b44a-391e-4575-8266-6e159eb7b275', '路由模式', 'React Router 提供了两种核心的路由模式：`HashRouter` 和 `BrowserRouter`，二者的本质区别在于**使用的 URL 格式不同**、**依赖的浏览器特性不同**，以及**服务端配置要求不同**。

# 1. 核心区别对比
| 特性                | HashRouter                          | BrowserRouter                      |
|---------------------|-------------------------------------|------------------------------------|
| URL 格式            | 包含 `#` 符号（如 `http://localhost:3000/#/home`） | 无 `#` 符号（如 `http://localhost:3000/home`） |
| 底层实现            | 基于浏览器的 `hashchange` 事件（监听 URL 中 `#` 后的变化） | 基于 HTML5 History API（`pushState`/`replaceState` + `popstate` 事件） |
| 服务端配置          | 无需服务端配置（`#` 后的内容不会发送到服务端） | 需服务端配置（刷新页面时需返回 index.html，否则 404） |
| SEO 友好性          | 不友好（搜索引擎可能忽略 `#` 后的内容） | 友好（URL 为真实路径，搜索引擎可正常爬取） |
| 兼容性              | 兼容所有浏览器（包括 IE 低版本）    | 仅兼容支持 HTML5 History API 的浏览器（IE10+） |
| 路径参数传递        | 支持（如 `#/users/:id`）            | 支持（如 `/users/:id`）            |
| 美观性              | 较差（URL 中有 `#` 符号）           | 较好（URL 简洁，与传统网站一致）   |

# 2. HashRouter 详解
## 2.1 工作原理
`HashRouter` 利用 URL 中的 **哈希值（`#` 后的部分）** 实现路由跳转：
- 哈希值的变化不会触发浏览器向服务端发送请求；
- 浏览器会监听 `hashchange` 事件，当哈希值变化时，React Router 匹配对应的路由组件并渲染。

## 2.2 使用方式
```jsx
import { HashRouter, Routes, Route } from ''react-router-dom'';
import Home from ''./pages/Home'';
import About from ''./pages/About'';

function App() {
  return (
    <HashRouter>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/about" element={<About />} />
      </Routes>
    </HashRouter>
  );
}
```

## 2.3 适用场景
- 静态网站（无服务端后端）：如部署在 GitHub Pages、Netlify 等静态托管平台的项目；
- 老项目兼容（需支持 IE 低版本）；
- 快速原型开发（无需配置服务端）。

## 2.4 局限性
- URL 中包含 `#` 符号，不够美观；
- 哈希值部分不会被服务端接收，无法通过服务端获取路由参数；
- 对 SEO 不友好，部分搜索引擎无法解析哈希后的内容。

# 3. BrowserRouter 详解
## 3.1 工作原理
`BrowserRouter` 基于 HTML5 的 **History API** 实现：
- 通过 `history.pushState()`/`history.replaceState()` 方法修改 URL 路径（不触发页面刷新）；
- 浏览器监听 `popstate` 事件（用户点击前进/后退按钮时），React Router 匹配路由并渲染组件；
- 当用户刷新页面时，浏览器会向服务端发送请求，请求当前 URL 对应的资源。

## 3.2 使用方式
```jsx
import { BrowserRouter, Routes, Route } from ''react-router-dom'';
import Home from ''./pages/Home'';
import About from ''./pages/About'';

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/about" element={<About />} />
      </Routes>
    </BrowserRouter>
  );
}
```

## 3.3 服务端配置要求
由于刷新页面时浏览器会请求当前 URL 路径，服务端需配置“所有路径都返回 index.html”（让前端路由接管），否则会出现 404 错误。以下是常见服务端的配置示例：

### （1）Nginx 配置
```nginx
server {
  listen 80;
  server_name your-domain.com;
  root /path/to/your/project/build;
  index index.html;

  # 所有请求都返回 index.html
  location / {
    try_files $uri $uri/ /index.html;
  }
}
```

### （2）Express 配置
```jsx
const express = require(''express'');
const path = require(''path'');
const app = express();

// 静态资源目录
app.use(express.static(path.join(__dirname, ''build'')));

// 所有请求返回 index.html
app.get(''*'', (req, res) => {
  res.sendFile(path.join(__dirname, ''build'', ''index.html''));
});

app.listen(3000, () => {
  console.log(''Server running on port 3000'');
});
```

### （3）GitHub Pages 配置
若需在 GitHub Pages 上使用 `BrowserRouter`，需添加 `404.html` 文件（内容与 `index.html` 相同），并配置 `basename`（项目仓库名）：
```jsx
<BrowserRouter basename="/your-repo-name">
  {/* 路由配置 */}
</BrowserRouter>
```

## 3.4 适用场景
- 有服务端后端的项目（可配置路由转发）；
- 对 SEO 有要求的项目（如官网、营销页）；
- 追求 URL 美观的现代前端项目。

## 3.5 局限性
- 依赖 HTML5 History API，不兼容 IE 9 及以下版本；
- 需服务端配置，否则刷新页面会出现 404；
- 若项目部署在子路径下（如 `https://example.com/app/`），需配置 `basename` 属性。

# 4. 如何选择路由模式？
1. **优先选 BrowserRouter**：
   - 项目有服务端支持（可配置路由转发）；
   - 对 SEO 和 URL 美观性有要求；
   - 无需兼容低版本 IE。

2. **选 HashRouter**：
   - 项目为纯静态页面（无服务端）；
   - 部署在无法配置服务端的平台（如部分免费静态托管）；
   - 需兼容 IE 低版本；
   - 快速开发原型，无需关心 URL 美观性。

# 5. 其他注意事项
1. **`basename` 属性**：当项目部署在域名的子路径下时（如 `https://example.com/my-app/`），需给路由组件配置 `basename` 属性，确保路由路径正确：
   ```jsx
   <BrowserRouter basename="/my-app">
   <HashRouter basename="/my-app">
   ```
2. **路由参数与哈希值**：`HashRouter` 中，哈希值后的路径同样支持动态参数（如 `#/users/:id`），使用 `useParams` 可正常获取；
3. **History 对象**：两种路由模式下，`useHistory`（v5）/`useNavigate`（v6）钩子的使用方式完全一致，无需区分；
4. **第三方工具兼容**：部分第三方工具（如埋点、分享链接）可能对哈希路由的支持不佳，需额外处理。', '77b830a2-38dc-41a0-8e20-9f29ffc5a332', 'true', '2025-12-22 02:13:08.528384+00', '2025-12-23 02:55:42.796275+00'), ('9aff2e40-d52e-43ac-8be4-d7f98ba94fc5', '函数组件 useState', '在 React 函数组件中，**useState** 是用于管理组件内部状态的 Hook，从 React 16.8 开始引入，彻底解决了函数组件无法存储内部状态的问题。相比类组件的 `state`，`useState` 更轻量、灵活，是函数组件状态管理的核心方案。

# 1. useState 基础用法
## 1.1 基本语法
`useState` 是一个函数，接收一个**初始状态值**作为参数，返回一个长度为 2 的数组：
- 数组第一个元素：**当前状态值**，类似于类组件的 `this.state`。
- 数组第二个元素：**状态更新函数**，类似于类组件的 `setState`，用于修改状态值。

语法结构：
```jsx
import { useState } from ''react'';

function Counter() {
  // 解构赋值：count 是当前状态，setCount 是更新函数，初始值为 0
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>计数：{count}</p>
      <button onClick={() => setCount(count + 1)}>+1</button>
    </div>
  );
}
```

## 1.2 初始化状态的两种方式
### （1）直接传递初始值（适用于初始值为简单类型且无需计算的场景）
初始值可以是任意 JavaScript 类型：数字、字符串、布尔值、数组、对象等。
```jsx
// 数字类型
const [age, setAge] = useState(18);
// 字符串类型
const [name, setName] = useState(''React'');
// 布尔类型
const [isVisible, setIsVisible] = useState(true);
// 数组类型
const [list, setList] = useState([''a'', ''b'', ''c'']);
// 对象类型
const [user, setUser] = useState({ name: ''张三'', age: 20 });
```

### （2）传递初始化函数（适用于初始值需要复杂计算的场景）
如果初始状态的计算逻辑比较复杂（如从本地存储读取数据、执行复杂运算），可以传递一个**无参函数**作为 `useState` 的参数，该函数的返回值会作为初始状态，且**只在组件首次渲染时执行一次**，避免重复计算。
```jsx
function UserProfile() {
  // 初始化函数：仅首次渲染执行
  const initUser = () => {
    console.log(''初始化用户数据（仅执行一次）'');
    return JSON.parse(localStorage.getItem(''user'')) || { name: ''匿名用户'' };
  };

  // 传递初始化函数，避免每次渲染都执行复杂计算
  const [user, setUser] = useState(initUser);

  return <p>用户名：{user.name}</p>;
}
```

## 1.3 核心特性
- **无 this 绑定**：函数组件没有 `this` 关键字，直接通过解构的变量访问状态，避免类组件的 `this` 指向问题。
- **状态独立**：多次调用 `useState` 可以定义多个独立的状态，状态之间互不影响。
  ```jsx
  function MultiState() {
    // 多个独立状态
    const [count, setCount] = useState(0);
    const [message, setMessage] = useState(''Hello'');
    const [isActive, setIsActive] = useState(false);

    return (
      <div>
        <p>计数：{count}</p>
        <p>消息：{message}</p>
        <p>状态：{isActive ? ''激活'' : ''未激活''}</p>
      </div>
    );
  }
  ```
- **触发重新渲染**：调用状态更新函数（如 `setCount`）后，函数组件会重新执行，使用新的状态值生成新的 UI。

# 2. 状态更新规则
## 2.1 基本更新方式
`useState` 的状态更新函数有两种调用方式，适用于不同场景：

### （1）直接传递新值（适用于不依赖旧状态的场景）
直接将新的状态值传递给更新函数，适用于状态更新不依赖当前状态的情况。
```jsx
function Counter() {
  const [count, setCount] = useState(0);

  // 直接传递新值
  const handleReset = () => setCount(0);

  return (
    <div>
      <p>计数：{count}</p>
      <button onClick={() => setCount(count + 1)}>+1</button>
      <button onClick={handleReset}>重置</button>
    </div>
  );
}
```

### （2）传递更新函数（适用于依赖旧状态的场景）
传递一个**回调函数**，函数接收**当前的旧状态**作为参数，返回新的状态值。适用于状态更新依赖旧状态的场景（如累加、数组追加）。
```jsx
function Counter() {
  const [count, setCount] = useState(0);

  // 传递更新函数：依赖旧状态计算新值
  const handleIncrement = () => {
    setCount(prevCount => prevCount + 1);
  };

  return (
    <div>
      <p>计数：{count}</p>
      <button onClick={handleIncrement}>+1</button>
    </div>
  );
}
```

## 2.2 关键更新规则
### （1）状态更新是“替换”而非“合并”
这是 `useState` 与类组件 `setState` 的核心区别：
- 类组件 `setState`：更新时会**合并**旧状态和新状态，未指定的属性会保留。
- 函数组件 `useState`：更新时会**直接替换**旧状态，未指定的属性会丢失。

```jsx
// 类组件 setState：合并更新
this.setState({ name: ''李四'' }); // age 属性会保留

// 函数组件 useState：替换更新
const [user, setUser] = useState({ name: ''张三'', age: 20 });
// 错误：更新后 age 属性会丢失，user 变为 { name: ''李四'' }
setUser({ name: ''李四'' });
```

### （2）如何实现对象/数组的“合并更新”？
要实现对象或数组的合并更新，需要借助**扩展运算符**（`...`），先复制旧状态的所有属性，再修改需要更新的属性。
```jsx
function UserProfile() {
  const [user, setUser] = useState({ name: ''张三'', age: 20 });

  // 对象合并更新：保留旧属性，修改新属性
  const updateAge = () => {
    setUser(prevUser => ({
      ...prevUser, // 复制旧对象的所有属性
      age: prevUser.age + 1 // 修改需要更新的属性
    }));
  };

  return (
    <div>
      <p>姓名：{user.name}</p>
      <p>年龄：{user.age}</p>
      <button onClick={updateAge}>年龄+1</button>
    </div>
  );
}
```

### （3）状态更新的“批量性”
与类组件 `setState` 类似，`useState` 的状态更新在 React 合成事件中也是**批量执行**的，多次调用更新函数会合并为一次渲染，提升性能。
```jsx
function BatchUpdate() {
  const [count, setCount] = useState(0);

  const handleBatch = () => {
    // 多次调用更新函数，合并为一次渲染
    setCount(prev => prev + 1);
    setCount(prev => prev + 1);
    setCount(prev => prev + 1);
  };

  return (
    <div>
      <p>计数：{count}</p>
      <button onClick={handleBatch}>批量+3</button>
    </div>
  );
}
```
点击按钮后，`count` 会从 `0` 直接变为 `3`，且组件只渲染一次。

# 3. 复杂状态管理
复杂状态指的是状态值为**数组**或**对象**的情况，这类状态的更新需要遵循“不可变数据”原则，避免直接修改原数据。

## 3.1 数组状态管理
数组状态的常见操作：添加元素、删除元素、修改元素，都需要通过**创建新数组**的方式更新，不能直接修改原数组。

```jsx
function TodoList() {
  // 初始化数组状态
  const [todos, setTodos] = useState([
    { id: 1, text: ''学习 React'', done: false }
  ]);

  // 1. 添加元素：创建新数组（原数组 + 新元素）
  const addTodo = () => {
    const newTodo = { id: Date.now(), text: ''新任务'', done: false };
    setTodos(prevTodos => [...prevTodos, newTodo]);
  };

  // 2. 删除元素：过滤出需要保留的元素，创建新数组
  const deleteTodo = (id) => {
    setTodos(prevTodos => prevTodos.filter(todo => todo.id !== id));
  };

  // 3. 修改元素：映射数组，更新指定元素
  const toggleTodo = (id) => {
    setTodos(prevTodos => 
      prevTodos.map(todo => 
        todo.id === id ? { ...todo, done: !todo.done } : todo
      )
    );
  };

  return (
    <div>
      <button onClick={addTodo}>添加任务</button>
      <ul>
        {todos.map(todo => (
          <li key={todo.id} style={{ textDecoration: todo.done ? ''line-through'' : ''none'' }}>
            {todo.text}
            <button onClick={() => deleteTodo(todo.id)}>删除</button>
            <button onClick={() => toggleTodo(todo.id)}>切换状态</button>
          </li>
        ))}
      </ul>
    </div>
  );
}
```

## 3.2 对象状态管理
对象状态的更新需要通过**扩展运算符**复制旧对象的属性，再修改目标属性，确保不直接修改原对象。

```jsx
function UserForm() {
  // 初始化对象状态
  const [form, setForm] = useState({
    username: '''',
    password: '''',
    remember: false
  });

  // 处理输入变化：更新对象的指定属性
  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;
    // 根据输入类型获取值（普通输入框取 value，复选框取 checked）
    const inputValue = type === ''checkbox'' ? checked : value;
    // 合并更新对象
    setForm(prevForm => ({
      ...prevForm,
      [name]: inputValue
    }));
  };

  return (
    <form>
      <div>
        <label>用户名：</label>
        <input name="username" value={form.username} onChange={handleChange} />
      </div>
      <div>
        <label>密码：</label>
        <input type="password" name="password" value={form.password} onChange={handleChange} />
      </div>
      <div>
        <label>
          <input type="checkbox" name="remember" checked={form.remember} onChange={handleChange} />
          记住我
        </label>
      </div>
      <button type="button" onClick={() => console.log(form)}>打印表单</button>
    </form>
  );
}
```

## 3.3 嵌套复杂状态管理
对于嵌套层级较深的状态（如 `{ user: { info: { address: ''北京'' } } }`），更新时需要逐层使用扩展运算符复制，确保每一层都是新对象。
```jsx
function NestedState() {
  const [data, setData] = useState({
    user: {
      name: ''张三'',
      info: {
        age: 20,
        address: ''北京''
      }
    }
  });

  // 更新嵌套的 address 属性
  const updateAddress = () => {
    setData(prevData => ({
      ...prevData, // 复制外层对象
      user: {
        ...prevData.user, // 复制 user 对象
        info: {
          ...prevData.user.info, // 复制 info 对象
          address: ''上海'' // 修改目标属性
        }
      }
    }));
  };

  return (
    <div>
      <p>地址：{data.user.info.address}</p>
      <button onClick={updateAddress}>修改地址</button>
    </div>
  );
}
```
> 注意：如果嵌套层级过深，使用 `useState` 会导致更新逻辑繁琐，此时推荐使用 `useReducer` 或第三方状态管理库（如 Redux）。

# 4. 核心总结
1. **基础用法**：
   - `useState` 接收初始值或初始化函数，返回 `[状态值, 更新函数]`。
   - 初始化函数仅在组件首次渲染时执行，适用于复杂初始值计算。
2. **状态更新规则**：
   - 直接传新值：适用于不依赖旧状态的场景。
   - 传更新函数：适用于依赖旧状态的场景，推荐优先使用。
   - 状态更新是“替换”而非“合并”，对象/数组更新需用扩展运算符实现合并。
3. **复杂状态管理**：
   - 数组更新：使用 `...`、`filter`、`map` 等方法创建新数组。
   - 对象更新：使用 `...` 复制旧对象属性，再修改目标属性。
   - 嵌套状态更新：逐层复制，避免直接修改原数据；层级过深时推荐使用 `useReducer`。...', 'e42a3397-52b2-470f-a87d-08e025ba6944', 'true', '2025-12-19 11:39:48.983418+00', '2025-12-19 11:39:48.983418+00'), ('9b51b490-31be-47b0-9690-e7b23ec7f718', 'useEffect：副作用处理', '`useEffect` 是 React 中用于处理**副作用**的核心 Hook，所谓“副作用”指的是组件渲染过程中无法完成的操作（如数据请求、DOM 操作、订阅/监听、定时器/延时器等）。`useEffect` 让函数组件具备了类似类组件生命周期的能力，统一管理组件的“挂载-更新-卸载”阶段的副作用逻辑。

# 1. 副作用的定义与分类
## 1.1 什么是副作用？
React 组件的核心职责是根据状态（state）和属性（props）渲染 UI，属于“纯逻辑”；而副作用是指：
- 与外部系统交互的操作（如调用 API 获取数据、操作 localStorage）。
- 会产生“持久化影响”的操作（如设置定时器、添加事件监听）。
- 直接操作 DOM 的操作（如修改 DOM 样式、获取 DOM 尺寸）。

这些操作无法在组件渲染期间执行（会导致渲染不一致），必须在渲染完成后执行，`useEffect` 正是为处理这类操作而生。

## 1.2 副作用的分类
- **无需清理的副作用**：执行后无需后续操作，如数据请求、DOM 一次性修改、日志打印。
- **需要清理的副作用**：执行后需要在组件卸载或更新前清理，如定时器、事件监听、订阅（避免内存泄漏）。

# 2. useEffect 基本语法与执行机制
## 2.1 基本语法
```jsx
import { useEffect } from ''react'';

useEffect(() => {
  // 副作用逻辑（组件渲染后执行）

  // 可选：清理函数（组件卸载或副作用重新执行前执行）
  return () => {
    // 清理逻辑（如清除定时器、取消监听）
  };
}, [依赖项数组]); // 控制 useEffect 执行时机的依赖项
```

## 2.2 核心参数说明
| 参数               | 作用                                                                 |
|--------------------|----------------------------------------------------------------------|
| 副作用函数         | 组件渲染后执行的逻辑，支持异步（但建议内部定义 async 函数，而非直接返回 Promise） |
| 清理函数（可选）| 副作用的“反向操作”，用于清理资源，避免内存泄漏                         |
| 依赖项数组（可选）| 决定 useEffect 何时执行：<br>1. 不传：组件每次渲染后都执行<br>2. 空数组：仅组件挂载后执行一次<br>3. 有值：仅当依赖项变化时执行 |

## 2.3 执行机制
- 组件首次渲染：执行副作用函数（挂载阶段）。
- 组件更新渲染：
  1. 先执行上一次副作用的清理函数（若有）。
  2. 再执行新的副作用函数（更新阶段）。
- 组件卸载：执行最后一次副作用的清理函数（卸载阶段）。

# 3. useEffect 的三种使用场景（依赖项控制）
## 场景1：无依赖项数组 → 每次渲染后执行
不传递依赖项数组时，`useEffect` 会在**组件每次渲染完成后执行**（包括首次渲染和每次更新渲染），相当于类组件的 `componentDidMount + componentDidUpdate`。

### 示例：实时更新文档标题
```jsx
function DocumentTitle() {
  const [count, setCount] = useState(0);

  // 无依赖项数组：每次渲染后执行
  useEffect(() => {
    console.log(''副作用执行：更新文档标题'');
    document.title = `当前计数：${count}`;
  }); // 注意：无依赖项数组

  return (
    <div>
      <p>计数：{count}</p>
      <button onClick={() => setCount(count + 1)}>+1</button>
    </div>
  );
}
```
> 缺点：组件每次更新（如 count 变化）都会执行副作用，若副作用逻辑复杂（如数据请求），会导致性能浪费，需谨慎使用。

## 场景2：空依赖项数组 → 仅挂载时执行一次
传递空数组 `[]` 作为依赖项时，`useEffect` 仅在**组件首次渲染完成后执行一次**（挂载阶段），且清理函数仅在组件卸载时执行，相当于类组件的 `componentDidMount + componentWillUnmount`。

### 示例1：无需清理的副作用（数据请求）
```jsx
function UserList() {
  const [users, setUsers] = useState([]);

  // 空依赖项：仅挂载时请求一次数据
  useEffect(() => {
    // 数据请求（副作用逻辑）
    const fetchUsers = async () => {
      const res = await fetch(''https://api.example.com/users'');
      const data = await res.json();
      setUsers(data);
    };
    fetchUsers();
  }, []); // 空依赖项数组

  return (
    <ul>
      {users.map(user => (
        <li key={user.id}>{user.name}</li>
      ))}
    </ul>
  );
}
```

### 示例2：需要清理的副作用（定时器）
```jsx
function Timer() {
  const [count, setCount] = useState(0);

  // 空依赖项：仅挂载时设置定时器，卸载时清除
  useEffect(() => {
    // 副作用逻辑：设置定时器
    const timer = setInterval(() => {
      setCount(prev => prev + 1);
    }, 1000);

    // 清理函数：组件卸载时清除定时器
    return () => {
      clearInterval(timer);
      console.log(''定时器已清除'');
    };
  }, []); // 空依赖项数组

  return <p>定时器计数：{count}</p>;
}
```

## 场景3：有依赖项数组 → 依赖变化时执行
传递包含变量/函数的依赖项数组时，`useEffect` 仅在**依赖项的值发生变化时执行**（首次渲染会执行一次，后续仅依赖变化执行），精准控制副作用的执行时机，是最常用的场景。

### 示例1：依赖 props 变化请求数据
```jsx
function UserDetail({ userId }) {
  const [user, setUser] = useState(null);

  // 依赖 userId：userId 变化时重新请求数据
  useEffect(() => {
    const fetchUser = async () => {
      const res = await fetch(`https://api.example.com/users/${userId}`);
      const data = await res.json();
      setUser(data);
    };
    fetchUser();

    // 清理函数：取消未完成的请求（可选）
    return () => {
      // 若使用 axios 可取消请求：source.cancel(''请求取消'')
    };
  }, [userId]); // 依赖项：userId

  if (!user) return <div>加载中...</div>;
  return (
    <div>
      <h2>{user.name}</h2>
      <p>年龄：{user.age}</p>
    </div>
  );
}
```

### 示例2：依赖 state 变化执行副作用
```jsx
function ThemeSwitcher() {
  const [theme, setTheme] = useState(''light'');

  // 依赖 theme：主题变化时修改 body 样式
  useEffect(() => {
    document.body.className = theme;
    console.log(`主题切换为：${theme}`);
  }, [theme]); // 依赖项：theme

  return (
    <div>
      <button onClick={() => setTheme(''light'')}>亮色主题</button>
      <button onClick={() => setTheme(''dark'')}>暗色主题</button>
    </div>
  );
}
```

# 4. 清理函数的作用与使用场景
清理函数是 `useEffect` 返回的可选函数，用于清理副作用产生的资源，避免内存泄漏，核心使用场景包括：

## 4.1 清除定时器/延时器
```jsx
useEffect(() => {
  const timer = setTimeout(() => {
    console.log(''延时执行'');
  }, 1000);

  // 清理函数：组件卸载或副作用重新执行时清除延时器
  return () => clearTimeout(timer);
}, []);
```

## 4.2 取消事件监听
```jsx
useEffect(() => {
  const handleResize = () => {
    console.log(''窗口尺寸变化：'', window.innerWidth);
  };

  // 副作用：添加窗口resize监听
  window.addEventListener(''resize'', handleResize);

  // 清理函数：移除监听
  return () => window.removeEventListener(''resize'', handleResize);
}, []);
```

## 4.3 取消订阅/数据请求
```jsx
useEffect(() => {
  // 副作用：订阅数据更新
  const subscription = dataService.subscribe(data => {
    console.log(''数据更新：'', data);
  });

  // 清理函数：取消订阅
  return () => subscription.unsubscribe();
}, []);
```

## 4.4 清理 DOM 操作痕迹
```jsx
useEffect(() => {
  // 副作用：添加全局样式
  document.body.style.backgroundColor = ''red'';

  // 清理函数：恢复原样式
  return () => {
    document.body.style.backgroundColor = '''';
  };
}, []);
```

# 5. useEffect 与类组件生命周期的对应关系
| useEffect 用法                | 类组件生命周期对应               | 执行时机                     |
|-------------------------------|----------------------------------|------------------------------|
| `useEffect(() => { ... })`    | `componentDidMount + componentDidUpdate` | 每次渲染后执行               |
| `useEffect(() => { ... }, [])`| `componentDidMount`              | 仅挂载时执行一次             |
| `useEffect(() => { return () => { ... } }, [])` | `componentDidMount + componentWillUnmount` | 挂载时执行副作用，卸载时执行清理 |
| `useEffect(() => { ... }, [dep])` | 自定义更新逻辑                   | 首次渲染 + dep 变化时执行    |

# 6. useEffect 常见陷阱与避坑指南
## 陷阱1：依赖项缺失导致无限循环
#### 问题：
副作用函数中修改了某个 state，但未将该 state 加入依赖项数组，导致每次渲染都执行副作用，修改 state 后再次渲染，形成无限循环：
```jsx
// 错误示例：依赖项缺失导致无限循环
function InfiniteLoop() {
  const [count, setCount] = useState(0);

  useEffect(() => {
    // 副作用中修改了 count，但未将 count 加入依赖项
    setCount(count + 1);
  }, []); // 空依赖项 → 期望仅执行一次，但实际无限循环

  return <p>count：{count}</p>;
}
```

#### 解决：
- 若依赖该 state，将其加入依赖项数组：
  ```jsx
  useEffect(() => {
    setCount(count + 1);
  }, [count]); // 加入依赖项，仅 count 变化时执行
  ```
- 若无需依赖当前值，使用更新函数（推荐）：
  ```jsx
  useEffect(() => {
    setCount(prev => prev + 1);
  }, []); // 无依赖，仅执行一次
  ```

## 陷阱2：异步函数直接返回 Promise
#### 问题：
`useEffect` 的副作用函数若直接返回 Promise（如使用 async/await 修饰），会导致 React 警告（因为 useEffect 期望返回清理函数或 undefined，而非 Promise）：
```jsx
// 错误示例：副作用函数返回 Promise
useEffect(async () => {
  const res = await fetch(''/api/data'');
  const data = await res.json();
  setData(data);
}, []);
```

#### 解决：
在副作用函数内部定义 async 函数并调用，避免直接返回 Promise：
```jsx
// 正确示例：内部定义 async 函数
useEffect(() => {
  const fetchData = async () => {
    const res = await fetch(''/api/data'');
    const data = await res.json();
    setData(data);
  };
  fetchData();
}, []);
```

## 陷阱3：闭包陷阱导致获取不到最新状态
#### 问题：
副作用函数形成闭包，捕获了渲染时的 state 值，后续 state 更新后，副作用函数仍使用旧值：
```jsx
// 闭包陷阱示例：定时器中获取的是初始 count 值
function ClosureTrap() {
  const [count, setCount] = useState(0);

  useEffect(() => {
    const timer = setInterval(() => {
      console.log(''count：'', count); // 始终输出 0，无法获取最新值
    }, 1000);
    return () => clearInterval(timer);
  }, []); // 空依赖项，副作用仅执行一次

  return (
    <div>
      <p>count：{count}</p>
      <button onClick={() => setCount(prev => prev + 1)}>+1</button>
    </div>
  );
}
```

#### 解决：
- 若需实时获取最新状态，将 state 加入依赖项数组：
  ```jsx
  useEffect(() => {
    const timer = setInterval(() => {
      console.log(''count：'', count); // 依赖 count，变化时重新创建定时器
    }, 1000);
    return () => clearInterval(timer);
  }, [count]); // 加入依赖项
  ```
- 若不想频繁重建定时器，使用 `useRef` 存储最新状态（后续 `useRef` 章节详细说明）。

## 陷阱4：忽略清理函数导致内存泄漏
#### 问题：
组件卸载后，未清理的副作用（如定时器、请求）仍在执行，修改已卸载组件的 state，导致控制台警告：
```jsx
// 内存泄漏示例：组件卸载后请求仍在执行
function LeakExample() {
  const [data, setData] = useState(null);

  useEffect(() => {
    fetch(''/api/data'').then(res => res.json()).then(data => {
      setData(data); // 组件卸载后执行，导致警告
    });
  }, []);

  return <div>{data ? data.name : ''加载中...''}</div>;
}
```

#### 解决：
- 使用 AbortController 取消请求：
  ```jsx
  useEffect(() => {
    const controller = new AbortController();
    const signal = controller.signal;

    fetch(''/api/data'', { signal }).then(res => res.json()).then(data => {
      setData(data);
    }).catch(err => {
      if (err.name !== ''AbortError'') console.error(err);
    });

    // 清理函数：取消请求
    return () => controller.abort();
  }, []);
  ```
- 添加组件挂载状态标记：
  ```jsx
  useEffect(() => {
    let isMounted = true; // 标记组件是否挂载

    fetch(''/api/data'').then(res => res.json()).then(data => {
      if (isMounted) setData(data); // 仅组件挂载时修改 state
    });

    // 清理函数：标记组件已卸载
    return () => {
      isMounted = false;
    };
  }, []);
  ```

# 7. 核心总结
1. **核心作用**：处理函数组件的副作用，统一管理组件挂载、更新、卸载阶段的非渲染逻辑。
2. **执行时机**：由依赖项数组控制，分为“每次渲染执行”“仅挂载执行”“依赖变化执行”三种场景。
3. **清理函数**：用于清理副作用资源（定时器、监听、订阅），避免内存泄漏，在组件卸载或副作用重新执行前执行。
4. **避坑要点**：
   - 依赖项数组必须包含副作用中使用的所有 state/props/函数。
   - 副作用函数内部定义 async 函数，避免直接返回 Promise。
   - 闭包陷阱需通过依赖项或 useRef 解决。
   - 异步操作需添加清理逻辑，避免组件卸载后修改 state。...', '8ef7f873-12e2-4aaf-933f-26eddf895f27', 'true', '2025-12-19 15:11:05.540486+00', '2025-12-22 02:00:02.894093+00'), ('9b611696-9f87-44b5-8c42-e1207769c5b4', ' Ant Design/Element Plus/MUI 选型与使用', '# 1. 三大组件库核心对比
| 特性                | Ant Design (AntD)                          | Element Plus                              | MUI (Material UI)                        |
|---------------------|--------------------------------------------|-------------------------------------------|-------------------------------------------|
| 设计语言            | 蚂蚁集团企业级设计体系（简约、专业）| 饿了么团队基于 Vue 生态的桌面端设计体系    | Google Material Design（拟物、动效）|
| 技术栈支持          | React 优先（Vue 版本为 AntD Vue）| Vue 3 优先（React 无官方版本）| React 专属                                |
| 组件丰富度          | 极高（200+ 组件，覆盖企业级场景）| 高（100+ 组件，聚焦中后台）| 高（100+ 组件，覆盖多端）|
| 生态与社区          | 国内生态成熟，中文文档完善                 | Vue 生态内活跃，中文文档完善              | 全球社区活跃，英文文档为主                |
| 定制化能力          | 支持主题定制、组件二次封装                 | 支持主题定制、按需引入                    | 支持 CSS-in-JS 深度定制、主题切换        |
| 国际化支持          | 内置多语言，支持自定义                     | 内置多语言，Vue I18n 集成                 | 内置多语言，i18next 集成                  |
| 适用场景            | 中后台系统、企业级应用                     | Vue 技术栈中后台系统                      | 移动端/桌面端 Material Design 风格应用    |
| 学习成本            | 低（中文文档，组件逻辑统一）| 低（Vue 生态友好，中文文档）| 中（CSS-in-JS 概念，英文文档）|

# 2. 选型决策依据
## 2.1 技术栈匹配
- 若项目基于 React：优先选择 AntD 或 MUI（AntD 更适配国内企业级场景，MUI 更适配 Material Design 设计）；
- 若项目基于 Vue：直接选择 Element Plus（无竞品替代）；
- 跨端项目（React Native）：MUI 有配套的 MUI X 支持，AntD 有 AntD Mobile。

## 2.2 设计风格匹配
- 企业级中后台：AntD/Element Plus（设计风格更贴合国内办公场景）；
- 消费级产品（ToC）：MUI（Material Design 更符合移动端用户习惯）；
- 定制化设计需求高：MUI（CSS-in-JS 支持更灵活的样式定制）。

## 2.3 功能需求匹配
- 需要复杂表单、表格、权限组件：AntD（ProComponents 扩展组件更强大）；
- 需要轻量化组件、快速开发：Element Plus（组件体积更小）；
- 需要 Material Design 动效、无障碍支持：MUI（原生支持 WCAG 标准）。

# 3. 快速上手（React 生态）
## 3.1 Ant Design 集成
### 3.1.1 安装依赖
```bash
npm install antd # 核心依赖
# 图标库（AntD 5.x 内置 @ant-design/icons，无需单独安装）
```

### 3.1.2 基础使用
```tsx
import React from ''react'';
import { Button, Space, message } from ''antd'';

const App = () => {
  const handleClick = () => {
    message.success(''AntD 按钮点击成功！'');
  };

  return (
    <Space direction="vertical" size="middle">
      <Button type="primary" onClick={handleClick}>
        主要按钮
      </Button>
      <Button type="default">默认按钮</Button>
      <Button type="dashed">虚线按钮</Button>
      <Button type="text">文本按钮</Button>
      <Button type="link">链接按钮</Button>
    </Space>
  );
};

export default App;
```

###  3.1.3 主题定制（ConfigProvider）
```tsx
import { ConfigProvider } from ''antd'';

const App = () => {
  return (
    <ConfigProvider
      theme={{
        token: {
          colorPrimary: ''#1890ff'', // 主色调
          fontSize: 14, // 基础字体大小
          borderRadius: 4, // 圆角大小
        },
      }}
    >
      {/* 应用内容 */}
      <Button type="primary">定制主题按钮</Button>
    </ConfigProvider>
  );
};
```

## 3.2 MUI 集成
### 3.2.1 安装依赖
```bash
npm install @mui/material @emotion/react @emotion/styled # 核心依赖
npm install @mui/icons-material # 图标库
```

### 3.2.2 基础使用
```tsx
import React from ''react'';
import Button from ''@mui/material/Button'';
import Box from ''@mui/material/Box'';
import Snackbar from ''@mui/material/Snackbar'';
import Alert from ''@mui/material/Alert'';

const App = () => {
  const [open, setOpen] = React.useState(false);

  const handleClick = () => {
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
  };

  return (
    <Box sx={{ display: ''flex'', gap: 2 }}>
      <Button variant="contained" onClick={handleClick}>
        Contained 按钮
      </Button>
      <Button variant="outlined">Outlined 按钮</Button>
      <Button variant="text">Text 按钮</Button>
      <Snackbar open={open} autoHideDuration={6000} onClose={handleClose}>
        <Alert onClose={handleClose} severity="success" sx={{ width: ''100%'' }}>
          MUI 按钮点击成功！
        </Alert>
      </Snackbar>
    </Box>
  );
};

export default App;
```

### 3.2.3 主题定制（ThemeProvider）
```tsx
import { createTheme, ThemeProvider } from ''@mui/material/styles'';
import Button from ''@mui/material/Button'';

// 自定义主题
const theme = createTheme({
  palette: {
    primary: {
      main: ''#1976d2'',
    },
    secondary: {
      main: ''#dc004e'',
    },
  },
  typography: {
    fontSize: 14,
  },
});

const App = () => {
  return (
    <ThemeProvider theme={theme}>
      <Button variant="contained" color="primary">
        定制主题按钮
      </Button>
    </ThemeProvider>
  );
};
```

# 4. 最佳实践
## 4.1 按需引入
- AntD 5.x 及 MUI 均支持 Tree Shaking，无需额外配置，直接导入组件即可；
- 避免全量导入（如 `import * as Antd from ''antd''`），减少打包体积。

## 4.2 组件二次封装
- 对高频使用的组件（如按钮、输入框）进行二次封装，统一业务逻辑和样式：
  ```tsx
  // AntD 按钮二次封装
  import { Button, ButtonProps } from ''antd'';

  interface MyButtonProps extends ButtonProps {
    bizType?: ''primary'' | ''danger'' | ''success'';
  }

  const MyButton = ({ bizType = ''primary'', children, ...props }: MyButtonProps) => {
    const typeMap = {
      primary: ''primary'',
      danger: ''danger'',
      success: ''success'',
    };

    return (
      <Button type={typeMap[bizType]} {...props}>
        {children}
      </Button>
    );
  };

  export default MyButton;
  ```

## 4.3 性能优化
- 避免频繁创建内联样式（如 MUI 的 `sx` 属性），抽离为常量；
- 对大数据表格（如 AntD Table）使用虚拟滚动（`scroll={{ y: 500 }}` + `pagination`）；
- 关闭不必要的动画（如 AntD 的 `motion` 配置）提升低性能设备体验。

# 5. 扩展生态
## 5.1 Ant Design 扩展
- **Ant Design Pro**：企业级中后台脚手架（https://pro.ant.design/）；
- **ProComponents**：高级组件库（表格、表单、布局，https://procomponents.ant.design/）；
- **Ant Design Mobile**：移动端组件库（https://mobile.ant.design/）。

## 5.2 MUI 扩展
- **MUI X**：高级组件库（数据网格、日期选择器，https://mui.com/x/）；
- **MUI Base**：无样式基础组件（支持自定义主题，https://mui.com/base/）；
- **MUI System**：样式工具库（https://mui.com/system/）。', '7fccb039-1e39-4894-ba93-5568169fef6e', 'true', '2025-12-22 03:21:17.172404+00', '2025-12-23 14:11:25.18823+00'), ('9bd6f57f-1784-4a42-9ece-7af926f0b70a', 'TypeScript 高级用法', '# 1. 泛型（Generics）
泛型是 TypeScript 的核心特性，用于创建可复用的类型组件，支持“类型参数化”—— 让类型像函数参数一样传递，解决类型固化问题。

## 1.1 泛型基础：函数泛型
需求：创建一个函数，接收任意类型的参数并返回相同类型的值：
```tsx
// 非泛型实现（类型固化，只能处理 string）
function returnValue(value: string): string {
  return value;
}

// 泛型实现（类型参数化，T 为类型变量）
function returnValue<T>(value: T): T {
  return value;
}

// 使用：显式指定类型
const str = returnValue<string>(''hello''); // str: string
const num = returnValue<number>(123); // num: number

// 自动推导类型（推荐）
const bool = returnValue(false); // bool: boolean
const arr = returnValue([1, 2, 3]); // arr: number[]
```
- `T` 是类型变量（可自定义名称，如 `U`/`V`），代表任意类型；
- 调用函数时，TypeScript 会根据传入的参数自动推导 `T` 的具体类型。

## 1.2 泛型接口/类型
泛型可用于接口或类型别名，创建通用的类型结构：
```tsx
// 泛型接口
interface Result<T> {
  code: number;
  data: T; // data 类型由 T 决定
  message: string;
}

// 使用：指定 T 为 User 类型
interface User {
  id: number;
  name: string;
}
const userResult: Result<User> = {
  code: 200,
  data: { id: 1, name: ''张三'' },
  message: ''success'',
};

// 指定 T 为商品数组类型
interface Product {
  id: number;
  price: number;
}
const productResult: Result<Product[]> = {
  code: 200,
  data: [{ id: 1, price: 99 }],
  message: ''success'',
};

// 泛型类型别名
type Container<T> = {
  value: T;
  label: string;
};

const stringContainer: Container<string> = { value: ''test'', label: ''字符串容器'' };
```

## 1.3 泛型组件（React 核心场景）
React 中泛型组件用于创建可复用的通用组件（如列表、表单组件）：
```tsx
// 泛型列表组件
interface ListProps<T> {
  data: T[];
  renderItem: (item: T, index: number) => React.ReactNode; // 渲染函数，接收 T 类型的 item
}

// 泛型函数组件（语法：<T,>(props: ListProps<T>) => ...）
const List = <T,>({ data, renderItem }: ListProps<T>) => {
  return (
    <ul>
      {data.map((item, index) => (
        <li key={index}>{renderItem(item, index)}</li>
      ))}
    </ul>
  );
};

// 使用：指定 T 为 User 类型
interface User {
  id: number;
  name: string;
}
const userList: User[] = [{ id: 1, name: ''张三'' }, { id: 2, name: ''李四'' }];

<List<User> 
  data={userList} 
  renderItem={(item) => <div>{item.name}</div>} 
/>

// 使用：指定 T 为 number 类型
<List<number> 
  data={[1, 2, 3]} 
  renderItem={(item) => <div>数字：{item}</div>} 
/>
```
- 泛型组件语法：函数组件需在参数前添加 `<T,>`（逗号避免与 JSX 标签混淆）；
- 调用组件时通过 `<T>` 指定具体类型，确保 `data` 和 `renderItem` 类型匹配。

## 1.4 泛型约束（Constraints）
泛型默认支持任意类型，通过 `extends` 可约束泛型的范围：
```tsx
// 约束 T 必须包含 id 属性
interface HasId {
  id: number;
}

// 泛型函数：仅处理包含 id 的对象
function findById<T extends HasId>(list: T[], id: number): T | undefined {
  return list.find(item => item.id === id);
}

// 正确：User 包含 id
interface User extends HasId { name: string; }
const users: User[] = [{ id: 1, name: ''张三'' }, { id: 2, name: ''李四'' }];
findById(users, 1); // 返回 User | undefined

// 错误：string[] 不包含 id 属性
findById([''a'', ''b''], 1); // TypeScript 报错
```

## 1.5 多泛型参数
支持多个类型变量，适用于关联多个类型的场景：
```tsx
function merge<T, U>(a: T, b: U): { a: T; b: U } {
  return { a, b };
}

const result = merge({ name: ''张三'' }, { age: 20 });
// result 类型：{ a: { name: string }; b: { age: number } }
```

# 2. 类型断言（Type Assertion）
类型断言用于告诉 TypeScript：“我知道这个值的具体类型，你不用推导了”，本质是类型覆盖（无运行时影响）。

## 2.1 语法
- 尖括号语法：`<类型>值`（React 中避免使用，与 JSX 冲突）；
- as 语法：`值 as 类型`（推荐，React 中唯一可用）。

## 2.2 常见场景
### 场景1：DOM 元素类型断言
`useRef` 初始值为 `null`，需断言为具体 DOM 类型：
```tsx
const inputRef = useRef<HTMLInputElement>(null);

useEffect(() => {
  // 断言 inputRef.current 不为 null（非空断言 + 类型断言）
  (inputRef.current as HTMLInputElement).focus();
  // 或简化（非空断言：! 表示排除 null/undefined）
  inputRef.current!.focus();
}, []);
```

### 场景2：API 响应数据类型断言
接口返回数据为 `any` 类型，需断言为具体类型：
```tsx
interface User {
  id: number;
  name: string;
}

const fetchUser = async () => {
  const res = await fetch(''/api/user'');
  const data = await res.json(); // data: any
  const user = data as User; // 断言为 User 类型
  console.log(user.name); // 类型安全
};
```

### 场景3：联合类型缩小范围
联合类型中需明确具体类型：
```tsx
type Data = string | number;

function handleData(data: Data) {
  if ((data as string).length) {
    // 断言为 string 类型，访问 length 属性
    console.log(''字符串长度：'', (data as string).length);
  } else {
    console.log(''数字：'', data);
  }
}
```

## 2.3 非空断言（!）
`!` 是特殊的类型断言，表示“该值不为 null/undefined”：
```tsx
const getElement = (): HTMLElement | null => {
  return document.getElementById(''test'');
};

const element = getElement();
element!.style.color = ''red''; // ! 断言 element 不为 null
```

## 2.4 类型断言的限制
类型断言不能完全违背类型体系，只能在“兼容类型”间转换：
```tsx
// 错误：string 与 number 不兼容
const num = ''123'' as number; // TypeScript 报错

// 正确：先断言为 any，再断言为 number（不推荐，避免滥用）
const num = ''123'' as any as number;
```

# 3. TypeScript 工具类型（Utility Types）
TypeScript 内置了一系列工具类型，用于快速转换类型，避免重复定义。以下是 React 项目中最常用的工具类型：

## 3.1 Partial<T>：将 T 的所有属性变为可选
```tsx
interface User {
  id: number;
  name: string;
  age: number;
}

// Partial<User> 等价于 { id?: number; name?: string; age?: number }
type PartialUser = Partial<User>;

// 场景：更新用户信息（无需传递所有属性）
const updateUser = (user: PartialUser) => { /* ... */ };
updateUser({ name: ''李四'' }); // 正确，仅更新 name
```

## 3.2 Required<T>：将 T 的所有属性变为必选
```tsx
interface User {
  id?: number;
  name?: string;
}

// Required<User> 等价于 { id: number; name: string }
type RequiredUser = Required<User>;

const user: RequiredUser = { id: 1, name: ''张三'' }; // 必须传递所有属性
```

## 3.3 Readonly<T>：将 T 的所有属性变为只读
```tsx
interface User {
  name: string;
}

// Readonly<User> 等价于 { readonly name: string }
type ReadonlyUser = Readonly<User>;

const user: ReadonlyUser = { name: ''张三'' };
user.name = ''李四''; // 错误：属性只读
```

## 3.4 Pick<T, K>：从 T 中挑选指定属性 K
```tsx
interface User {
  id: number;
  name: string;
  age: number;
  email: string;
}

// Pick<User, ''name'' | ''age''> 等价于 { name: string; age: number }
type UserInfo = Pick<User, ''name'' | ''age''>;

const userInfo: UserInfo = { name: ''张三'', age: 20 }; // 仅包含 name 和 age
```

## 3.5 Omit<T, K>：从 T 中排除指定属性 K
```tsx
interface User {
  id: number;
  name: string;
  age: number;
  email: string;
}

// Omit<User, ''id'' | ''email''> 等价于 { name: string; age: number }
type UserInfo = Omit<User, ''id'' | ''email''>;

const userInfo: UserInfo = { name: ''张三'', age: 20 }; // 排除 id 和 email
```

## 3.6 Exclude<T, U>：从 T 中排除可赋值给 U 的类型
```tsx
// Exclude<string | number | boolean, number> 等价于 string | boolean
type MyType = Exclude<string | number | boolean, number>;

const a: MyType = ''hello''; // 正确
const b: MyType = 123; // 错误：排除了 number
```

## 3.7 Extract<T, U>：从 T 中提取可赋值给 U 的类型
```tsx
// Extract<string | number | boolean, number | boolean> 等价于 number | boolean
type MyType = Extract<string | number | boolean, number | boolean>;

const a: MyType = 123; // 正确
const b: MyType = true; // 正确
const c: MyType = ''hello''; // 错误：未提取 string
```

## 3.8 Record<K, T>：创建键为 K、值为 T 的对象类型
```tsx
// Record<string, number> 等价于 { [key: string]: number }
type Score = Record<string, number>;

const score: Score = {
  math: 90,
  english: 85,
};

// 结合联合类型指定键名
type Subject = ''math'' | ''english'' | ''chinese'';
type SubjectScore = Record<Subject, number>;

const subjectScore: SubjectScore = {
  math: 90,
  english: 85,
  chinese: 95,
};
```

## 3.9 ReturnType<T>：获取函数 T 的返回值类型
```tsx
function getUser() {
  return { id: 1, name: ''张三'', age: 20 };
}

// ReturnType<typeof getUser> 等价于 { id: number; name: string; age: number }
type User = ReturnType<typeof getUser>;

const user: User = { id: 2, name: ''李四'', age: 25 }; // 类型匹配
```

## 3.10 Parameters<T>：获取函数 T 的参数类型（数组）
```tsx
function add(a: number, b: string): number {
  return a + Number(b);
}

// Parameters<typeof add> 等价于 [number, string]
type AddParams = Parameters<typeof add>;

const params: AddParams = [123, ''456'']; // 正确
add(...params); // 调用函数
```

# 4. 工具类型组合使用
实际项目中常组合多个工具类型，实现复杂类型转换：
```tsx
interface User {
  id: number;
  name: string;
  age: number;
  email: string;
  password: string;
}

// 需求1：创建用户表单类型（排除 id，其他可选）
type UserForm = Partial<Omit<User, ''id''>>;
// 等价于：{ name?: string; age?: number; email?: string; password?: string }

// 需求2：创建用户展示类型（挑选 name/age，且只读）
type UserDisplay = Readonly<Pick<User, ''name'' | ''age''>>;
// 等价于：{ readonly name: string; readonly age: number }

// 需求3：创建 API 响应类型（通用结果 + 用户数据）
type ApiResponse<T> = {
  code: number;
  message: string;
  data: T;
};

type UserApiResponse = ApiResponse<User>;
// 等价于：{ code: number; message: string; data: User }
```

# 5. 类型守卫（Type Guard）
类型守卫用于在运行时判断类型，缩小类型范围，常与联合类型配合：

## 5.1 typeof 类型守卫
判断基础类型（string/number/boolean 等）：
```tsx
type Data = string | number;

function handleData(data: Data) {
  if (typeof data === ''string'') {
    // 此处 data 被推断为 string 类型
    console.log(data.length);
  } else {
    // 此处 data 被推断为 number 类型
    console.log(data.toFixed(2));
  }
}
```

## 5.2 instanceof 类型守卫
判断类实例类型：
```tsx
class User {
  name: string;
  constructor(name: string) {
    this.name = name;
  }
}

class Product {
  price: number;
  constructor(price: number) {
    this.price = price;
  }
}

type Item = User | Product;

function handleItem(item: Item) {
  if (item instanceof User) {
    // 此处 item 被推断为 User 类型
    console.log(item.name);
  } else {
    // 此处 item 被推断为 Product 类型
    console.log(item.price);
  }
}
```

## 5.3 自定义类型守卫
通过 `is` 关键字定义自定义类型判断：
```tsx
interface Cat {
  type: ''cat'';
  meow: () => void;
}

interface Dog {
  type: ''dog'';
  bark: () => void;
}

type Animal = Cat | Dog;

// 自定义类型守卫：判断是否为 Cat
function isCat(animal: Animal): animal is Cat {
  return animal.type === ''cat'';
}

function handleAnimal(animal: Animal) {
  if (isCat(animal)) {
    // 此处 animal 被推断为 Cat 类型
    animal.meow();
  } else {
    // 此处 animal 被推断为 Dog 类型
    animal.bark();
  }
}
```...', 'f9e86587-de73-4459-b574-fbd8be79b7c1', 'true', '2025-12-22 03:20:11.480142+00', '2025-12-23 13:37:57.613623+00'), ('9bfcb4a8-5b96-4bce-9814-06785c13efad', 'useState：状态管理核心', '`useState` 是 React 中最基础、最核心的 Hook，用于在函数组件中添加和管理局部状态，是函数组件实现“状态化”的核心方案。从 React 16.8 引入 Hooks 开始，`useState` 彻底解决了函数组件无法存储内部状态的痛点，让函数组件具备了与类组件同等的状态管理能力。

# 1. useState 基本概念与原理
## 1.1 核心定义
`useState` 是一个**内置函数**，接收一个**初始状态值**作为参数，返回一个包含两个元素的数组：
- 第一个元素：`state` → 当前的状态值，类比类组件的 `this.state`。
- 第二个元素：`setState` → 状态更新函数，类比类组件的 `this.setState`，用于修改状态值并触发组件重新渲染。

## 1.2 工作原理
- 组件首次渲染时，`useState` 会根据传入的初始值初始化状态，并将状态存储在 React 的内部状态管理队列中。
- 调用 `setState` 时，React 会更新对应的状态值，并将组件标记为“需要重新渲染”。
- 组件重新渲染时，`useState` 会返回更新后的最新状态值，而非初始值（初始值仅在首次渲染生效）。

# 2. useState 基础用法
## 2.1 基本语法与解构
```jsx
import { useState } from ''react'';

function Counter() {
  // 解构赋值：count 是状态值，setCount 是更新函数，初始值为 0
  const [count, setCount] = useState(0);

  // 状态更新逻辑：点击按钮调用 setCount 修改 count
  const handleIncrement = () => {
    setCount(count + 1);
  };

  return (
    <div>
      <p>当前计数：{count}</p>
      <button onClick={handleIncrement}>+1</button>
    </div>
  );
}
```

## 2.2 初始值的两种设置方式
### （1）直接传递初始值（简单场景）
初始值可以是任意 JavaScript 类型（数字、字符串、布尔、数组、对象），适用于初始值无需计算的场景：
```jsx
// 数字
const [age, setAge] = useState(18);
// 字符串
const [name, setName] = useState(''React'');
// 布尔
const [isShow, setIsShow] = useState(false);
// 数组
const [list, setList] = useState([''a'', ''b'', ''c'']);
// 对象
const [user, setUser] = useState({ name: ''张三'', age: 20 });
```

### （2）传递初始化函数（复杂场景）
如果初始值需要通过**复杂计算**（如从本地存储读取、执行API请求、复杂运算）得到，建议传递一个**无参函数**作为 `useState` 的参数。该函数仅在**组件首次渲染时执行一次**，避免每次渲染重复计算，优化性能：
```jsx
function UserProfile() {
  // 初始化函数：仅首次渲染执行
  const initUser = () => {
    console.log(''初始化用户数据（仅执行一次）'');
    return JSON.parse(localStorage.getItem(''user'')) || { name: ''匿名用户'' };
  };

  // 传递初始化函数，而非直接传递计算结果
  const [user, setUser] = useState(initUser);

  return <p>用户名：{user.name}</p>;
}
```
> 注意：若直接传递计算结果（如 `useState(JSON.parse(localStorage.getItem(''user'')))`），则每次组件渲染都会执行该计算，导致性能浪费。

## 2.3 多状态管理
`useState` 支持在一个组件中多次调用，实现多个独立状态的管理，状态之间互不干扰：
```jsx
function MultiStateComponent() {
  // 多个独立状态
  const [count, setCount] = useState(0);
  const [message, setMessage] = useState(''Hello React'');
  const [isActive, setIsActive] = useState(true);

  return (
    <div>
      <p>计数：{count}</p>
      <p>消息：{message}</p>
      <p>状态：{isActive ? ''激活'' : ''未激活''}</p>
      <button onClick={() => setCount(count + 1)}>计数+1</button>
      <button onClick={() => setMessage(''Hello Hooks'')}>修改消息</button>
      <button onClick={() => setIsActive(!isActive)}>切换状态</button>
    </div>
  );
}
```

# 3. 状态更新的两种方式
## 3.1 直接传递新值（非依赖更新）
适用于状态更新**不依赖当前状态值**的场景，直接将新值传递给 `setState`：
```jsx
// 重置计数为 0（不依赖当前 count 值）
setCount(0);
// 修改消息为固定内容（不依赖当前 message 值）
setMessage(''新消息'');
```

## 3.2 传递更新函数（依赖更新）
适用于状态更新**依赖当前状态值**的场景（如累加、数组追加），传递一个接收 `prevState`（当前状态值）的回调函数，返回新的状态值。这种方式能确保获取到最新的状态值，避免批量更新导致的错误：
```jsx
// 累加：依赖当前 count 值，使用更新函数
setCount(prevCount => prevCount + 1);

// 数组追加：依赖当前 list 值，使用更新函数
setList(prevList => [...prevList, ''d'']);
```

### 为什么需要更新函数？
React 的状态更新在合成事件中是**批量执行**的，多次直接传递新值可能导致基于旧状态计算的错误：
```jsx
// 错误示例：多次直接更新，最终 count 只加 1
const handleBatchAdd = () => {
  setCount(count + 1);
  setCount(count + 1);
  setCount(count + 1);
};

// 正确示例：使用更新函数，最终 count 加 3
const handleBatchAdd = () => {
  setCount(prev => prev + 1);
  setCount(prev => prev + 1);
  setCount(prev => prev + 1);
};
```

# 4. 复杂状态管理（数组/对象）
`useState` 管理数组、对象等复杂类型时，需遵循**不可变数据原则**：不直接修改原状态，而是创建新的数组/对象替换原状态（因为 React 是通过引用比较判断状态是否变化的）。

## 4.1 数组状态管理
| 操作       | 实现方式（创建新数组）| 示例                                                                 |
|------------|---------------------------------|----------------------------------------------------------------------|
| 添加元素   | 扩展运算符（...）+ 新元素       | `setList(prev => [...prev, ''new item''])`                             |
| 删除元素   | filter 过滤                     | `setList(prev => prev.filter(item => item.id !== targetId))`         |
| 修改元素   | map 映射                        | `setList(prev => prev.map(item => item.id === targetId ? {...item, name: ''新名称''} : item))` |
| 清空数组   | 直接设置空数组                  | `setList([])`                                                        |

### 示例：待办事项列表
```jsx
function TodoList() {
  const [todos, setTodos] = useState([
    { id: 1, text: ''学习 useState'', done: false }
  ]);

  // 添加待办
  const addTodo = () => {
    const newTodo = { id: Date.now(), text: ''新待办'', done: false };
    setTodos(prev => [...prev, newTodo]);
  };

  // 切换待办状态
  const toggleTodo = (id) => {
    setTodos(prev => prev.map(todo => 
      todo.id === id ? { ...todo, done: !todo.done } : todo
    ));
  };

  // 删除待办
  const deleteTodo = (id) => {
    setTodos(prev => prev.filter(todo => todo.id !== id));
  };

  return (
    <div>
      <button onClick={addTodo}>添加待办</button>
      <ul>
        {todos.map(todo => (
          <li key={todo.id} style={{ textDecoration: todo.done ? ''line-through'' : ''none'' }}>
            {todo.text}
            <button onClick={() => toggleTodo(todo.id)}>切换</button>
            <button onClick={() => deleteTodo(todo.id)}>删除</button>
          </li>
        ))}
      </ul>
    </div>
  );
}
```

## 4.2 对象状态管理
| 操作       | 实现方式（创建新对象）| 示例                                                                 |
|------------|---------------------------------|----------------------------------------------------------------------|
| 修改属性   | 扩展运算符（...）+ 新属性       | `setUser(prev => ({ ...prev, age: 21 }))`                            |
| 添加属性   | 扩展运算符（...）+ 新属性       | `setUser(prev => ({ ...prev, address: ''北京'' }))`                    |
| 删除属性   | 解构赋值 + rest 运算符          | `setUser(prev => { const { age, ...rest } = prev; return rest; })`   |

### 示例：用户信息表单
```jsx
function UserForm() {
  const [form, setForm] = useState({
    username: '''',
    password: '''',
    remember: false
  });

  // 统一处理输入变化
  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;
    // 复选框取 checked，其他输入取 value
    const inputValue = type === ''checkbox'' ? checked : value;
    // 合并更新对象（创建新对象）
    setForm(prev => ({
      ...prev,
      [name]: inputValue
    }));
  };

  return (
    <form>
      <div>
        <label>用户名：</label>
        <input name="username" value={form.username} onChange={handleChange} />
      </div>
      <div>
        <label>密码：</label>
        <input type="password" name="password" value={form.password} onChange={handleChange} />
      </div>
      <div>
        <label>
          <input type="checkbox" name="remember" checked={form.remember} onChange={handleChange} />
          记住我
        </label>
      </div>
    </form>
  );
}
```

# 5. useState 与类组件 state 的对比
| 特性                | useState（函数组件）| 类组件 state                          |
|---------------------|---------------------------------------|---------------------------------------|
| 状态定义            | 多次调用，多个独立状态                | 单一对象，所有状态合并管理            |
| 状态更新            | 直接替换（非合并），需手动合并复杂类型 | 自动合并（仅更新指定属性，其他保留）  |
| 初始值              | 支持初始化函数（仅首次执行）| 仅支持构造函数初始化                  |
| 依赖更新            | 需传递更新函数确保最新状态            | 需传递函数式 setState 确保最新状态    |
| 语法简洁性          | 简洁，无 this 绑定问题                | 繁琐，需处理 this 指向                |

# 6. 核心总结
1. **核心作用**：为函数组件提供局部状态管理能力，是函数组件实现交互的基础。
2. **基本用法**：`const [state, setState] = useState(initialValue)`，初始值支持直接传递或通过初始化函数传递。
3. **状态更新**：
   - 非依赖更新：直接传递新值。
   - 依赖更新：传递接收 `prevState` 的回调函数，确保获取最新状态。
4. **复杂状态**：数组/对象更新需遵循不可变原则，通过扩展运算符、filter、map 等创建新数据，避免直接修改原状态。
5. **性能优化**：初始化复杂状态时使用初始化函数，避免重复计算；依赖更新时使用回调函数，避免批量更新错误。...', '8ef7f873-12e2-4aaf-933f-26eddf895f27', 'true', '2025-12-19 15:10:44.07384+00', '2025-12-22 01:56:38.311537+00'), ('9cae0857-0fb3-477f-8269-d7141868102d', 'useMemo：缓存计算结果', '`useMemo` 是 React 中用于**缓存复杂计算结果**的 Hook，核心作用是优化组件性能：避免组件每次渲染时重复执行昂贵的计算（如大数据排序、复杂数学运算、深层对象克隆）。在 React 中，函数组件每次渲染时，内部的所有代码都会重新执行，若包含昂贵计算，会严重影响渲染性能，`useMemo` 通过缓存计算结果，仅在依赖项变化时重新计算，解决这一问题。

# 1. useMemo 核心原理与问题背景
## 1.1 问题背景：重复昂贵计算导致的性能问题
函数组件每次渲染时，内部的计算逻辑会重新执行，若计算逻辑复杂（如处理大量数据），会显著增加渲染时间：
```jsx
import { useState } from ''react'';

// 昂贵计算：对大数据数组排序
function expensiveCalculation(list) {
  console.log(''执行昂贵计算'');
  return list.sort((a, b) => b - a); // 排序操作（大数据下性能差）
}

function DataProcessor() {
  const [count, setCount] = useState(0);
  const [data] = useState([1, 3, 2, 5, 4, 7, 6, 9, 8, 10]); // 模拟大数据

  // 每次组件渲染，都会执行 expensiveCalculation（即使 data 未变化）
  const sortedData = expensiveCalculation([...data]);

  return (
    <div>
      <p>count：{count}</p>
      <button onClick={() => setCount(prev => prev + 1)}>+1</button>
      <ul>
        {sortedData.map((item, index) => (
          <li key={index}>{item}</li>
        ))}
      </ul>
    </div>
  );
}
```
上述代码中，点击“+1”按钮会触发组件重渲染，尽管 `data` 状态未变化，但 `expensiveCalculation` 仍会重新执行（控制台打印“执行昂贵计算”），造成不必要的性能开销（大数据场景下更明显）。

## 1.2 useMemo 核心原理
`useMemo` 接收两个参数：
- 第一个参数：**计算函数**，返回需要缓存的结果（如昂贵计算的结果）。
- 第二个参数：**依赖项数组**（与 `useEffect`/`useCallback` 一致）。

返回值：缓存的计算结果（仅当依赖项变化时，才会重新执行计算函数；依赖项不变时，直接返回缓存的结果）。

## 1.3 基本语法
```jsx
import { useMemo } from ''react'';

const cachedValue = useMemo(() => {
  // 昂贵计算逻辑
  return expensiveCalculation(dep1, dep2);
}, [dep1, dep2]); // 依赖项数组：仅当 dep1/dep2 变化时，重新计算
```

# 2. useMemo 基础用法：优化昂贵计算
## 2.1 优化上述示例
使用 `useMemo` 缓存排序结果，仅当 `data` 变化时重新排序：
```jsx
import { useState, useMemo } from ''react'';

function expensiveCalculation(list) {
  console.log(''执行昂贵计算'');
  return list.sort((a, b) => b - a);
}

function DataProcessor() {
  const [count, setCount] = useState(0);
  const [data] = useState([1, 3, 2, 5, 4, 7, 6, 9, 8, 10]);

  // 使用 useMemo 缓存计算结果，依赖项为 data
  const sortedData = useMemo(() => {
    return expensiveCalculation([...data]);
  }, [data]); // 仅 data 变化时，重新执行昂贵计算

  return (
    <div>
      <p>count：{count}</p>
      <button onClick={() => setCount(prev => prev + 1)}>+1</button>
      <ul>
        {sortedData.map((item, index) => (
          <li key={index}>{item}</li>
        ))}
      </ul>
    </div>
  );
}
```
优化后，点击“+1”按钮时，组件重渲染但 `data` 未变化，`sortedData` 直接使用缓存结果，`expensiveCalculation` 不再执行（控制台仅首次渲染时打印“执行昂贵计算”），性能显著提升。

## 2.2 带多依赖项的 useMemo
若计算结果依赖多个变量，需将所有依赖项加入数组，确保计算结果的正确性：
```jsx
function PriceCalculator({ basePrice, discount, taxRate }) {
  // 计算最终价格：(basePrice - discount) * (1 + taxRate)
  const finalPrice = useMemo(() => {
    console.log(''计算最终价格'');
    return (basePrice - discount) * (1 + taxRate);
  }, [basePrice, discount, taxRate]); // 依赖所有相关变量

  return <p>最终价格：{finalPrice.toFixed(2)}</p>;
}
```
此时，仅当 `basePrice`/`discount`/`taxRate` 中任意一个变化时，才会重新计算最终价格。

# 3. useMemo 的其他适用场景
## 场景1：避免传递给子组件的复杂 props 引用变化
若父组件传递给子组件的 props 是复杂对象/数组（通过计算生成），每次渲染时会创建新的引用，即使内容未变化，也会导致子组件（使用 `React.memo`）重渲染。使用 `useMemo` 缓存该对象/数组，可避免此问题：
```jsx
import { useState, memo, useMemo } from ''react'';

// 子组件：使用 memo 优化
const UserList = memo(({ users }) => {
  console.log(''UserList 重渲染'');
  return (
    <ul>
      {users.map(user => (
        <li key={user.id}>{user.name}</li>
      ))}
    </ul>
  );
});

function Parent() {
  const [count, setCount] = useState(0);
  const [rawUsers] = useState([
    { id: 1, name: ''张三'', age: 20 },
    { id: 2, name: ''李四'', age: 25 },
    { id: 3, name: ''王五'', age: 30 }
  ]);

  // 过滤用户：仅显示年龄 ≥25 的用户
  // 使用 useMemo 缓存过滤结果，避免每次渲染创建新数组
  const filteredUsers = useMemo(() => {
    return rawUsers.filter(user => user.age >= 25);
  }, [rawUsers]); // 依赖 rawUsers

  return (
    <div>
      <p>count：{count}</p>
      <button onClick={() => setCount(prev => prev + 1)}>+1</button>
      {/* 传递缓存的数组，UserList 不会因 count 变化而重渲染 */}
      <UserList users={filteredUsers} />
    </div>
  );
}
```

## 场景2：缓存组件的派生状态
派生状态指由基础状态计算得到的状态（如从 `todos` 中计算未完成的数量），使用 `useMemo` 缓存派生状态，避免重复计算：
```jsx
function TodoStats() {
  const [todos, setTodos] = useState([
    { id: 1, text: ''学习 React'', done: false },
    { id: 2, text: ''学习 useMemo'', done: true },
    { id: 3, text: ''写代码'', done: false }
  ]);

  // 缓存派生状态：未完成的待办数量
  const unfinishedCount = useMemo(() => {
    console.log(''计算未完成数量'');
    return todos.filter(todo => !todo.done).length;
  }, [todos]); // 依赖 todos

  return <p>未完成待办：{unfinishedCount}</p>;
}
```

## 场景3：缓存 React 元素（减少组件重建）
在某些场景下，可使用 `useMemo` 缓存 React 元素，避免每次渲染重建组件树（适用于静态元素或低频变化元素）：
```jsx
function StaticComponent() {
  console.log(''StaticComponent 渲染'');
  return <div>静态内容（无需频繁重建）</div>;
}

function Parent() {
  const [count, setCount] = useState(0);

  // 缓存静态组件，避免每次渲染重建
  const cachedStaticComponent = useMemo(() => <StaticComponent />, []);

  return (
    <div>
      <p>count：{count}</p>
      <button onClick={() => setCount(prev => prev + 1)}>+1</button>
      {cachedStaticComponent}
    </div>
  );
}
```

# 4. useMemo 的使用误区
## 误区1：滥用 useMemo（缓存简单计算）
`useMemo` 本身有性能开销（需要维护缓存、对比依赖项），若计算逻辑简单（如加法、字符串拼接），使用 `useMemo` 反而会增加性能负担：
```jsx
// 错误示例：不必要的 useMemo
function SimpleCalculation() {
  const [a, setA] = useState(1);
  const [b, setB] = useState(2);

  // 简单加法，无需缓存
  const sum = useMemo(() => a + b, [a, b]);

  return <p>和：{sum}</p>;
}
```

## 误区2：依赖项缺失或错误
若计算函数使用了某个变量，但未加入依赖项数组，会导致缓存结果过期（使用旧值）：
```jsx
// 错误示例：依赖项缺失
function MissingDeps() {
  const [a, setA] = useState(1);
  const [b, setB] = useState(2);

  // 计算 a + b，但依赖项仅包含 a（缺失 b）
  const sum = useMemo(() => a + b, [a]);

  return (
    <div>
      <button onClick={() => setB(prev => prev + 1)}>b+1</button>
      <p>和：{sum}</p> {/* b 变化后，sum 仍使用旧值 */}
    </div>
  );
}
```

## 误区3：缓存不稳定的对象/数组
若计算函数返回的是“不稳定”的对象/数组（如每次创建新对象），即使使用 `useMemo`，也可能导致子组件重渲染：
```jsx
// 错误示例：返回新对象，缓存无效
function UnstableObject() {
  const [count, setCount] = useState(0);

  const user = useMemo(() => {
    // 每次执行都会创建新对象（引用不同）
    return { name: ''张三'', age: 20 };
  }, []);

  return <Child user={user} />; // 即使 useMemo，user 引用不变（此示例中是稳定的，仅说明风险）
}
```
> 注意：上述示例中 `user` 是稳定的（依赖项为空），但如果计算函数内部使用变量生成对象，需确保对象引用稳定。

## 误区4：将 useMemo 用于副作用
`useMemo` 的第一个参数是**计算函数**，必须是纯函数（无副作用，如数据请求、DOM 操作），副作用应使用 `useEffect`：
```jsx
// 错误示例：useMemo 中执行副作用
function SideEffectInUseMemo() {
  useMemo(() => {
    // 副作用：数据请求（错误用法）
    fetch(''/api/data'').then(res => res.json());
  }, []);

  return <div>错误示例</div>;
}
```

# 5. useMemo 与 useCallback 的区别与联系
## 5.1 区别
| 特性         | useMemo                          | useCallback                      |
|--------------|---------------------------------|---------------------------------|
| 缓存内容     | 函数执行的**结果**（值、对象、数组、元素） | 函数**引用**（未执行的函数）|
| 执行时机     | 组件渲染时执行计算函数，返回结果 | 组件渲染时返回函数引用，函数需手动调用 |
| 适用场景     | 缓存昂贵计算结果、稳定 props 引用 | 缓存回调函数、避免子组件重渲染 |
| 语法         | `useMemo(() => compute(), deps)` | `useCallback(() => {}, deps)`   |

## 5.2 联系
- 均用于性能优化，依赖项数组机制完全一致。
- 均在组件渲染时同步执行（阻塞渲染，因此不能缓存过于昂贵的计算，否则会延长渲染时间）。
- `useCallback(fn, deps)` 等价于 `useMemo(() => fn, deps)`（缓存函数引用）。

## 5.3 选择原则
- 需要缓存“计算结果”→ 使用 `useMemo`。
- 需要缓存“函数本身”→ 使用 `useCallback`。

# 6. useMemo 最佳实践
## 6.1 仅缓存昂贵计算
遵循“成本收益”原则：
- 计算时间 > 1ms（如大数据排序、深层对象处理）→ 使用 `useMemo`。
- 简单计算（如四则运算、简单过滤）→ 无需使用。

## 6.2 正确设置依赖项
- 计算函数中使用的所有变量（state、props、局部变量）必须加入依赖项数组。
- 使用 ESLint 规则 `react-hooks/exhaustive-deps` 检查依赖项完整性。
- 依赖项数组为空 → 计算结果永久缓存（仅首次渲染执行）。

## 6.3 避免缓存包含函数的对象
若缓存的对象包含函数，需确保函数引用稳定（使用 `useCallback` 缓存函数）：
```jsx
function UserActions() {
  const [user, setUser] = useState({ name: ''张三'' });

  // 缓存包含函数的对象，函数需用 useCallback 缓存
  const userActions = useMemo(() => ({
    updateName: useCallback((newName) => {
      setUser(prev => ({ ...prev, name: newName }));
    }, [])
  }), []);

  return <Child actions={userActions} />;
}
```

## 6.4 结合 React.memo 使用
当缓存的结果作为 props 传递给子组件时，子组件必须使用 `React.memo` 优化，否则 `useMemo` 无法发挥作用。

# 7. 核心总结
1. **核心作用**：缓存昂贵计算的结果，避免组件每次渲染时重复执行复杂计算，优化渲染性能。
2. **使用条件**：
   - 计算逻辑昂贵（大数据处理、复杂运算）。
   - 计算结果作为 props 传递给 `memo` 包装的子组件（需稳定引用）。
   - 计算结果为派生状态（需避免重复计算）。
3. **关键语法**：`useMemo(() => computeResult(), [deps])`，依赖项必须完整。
4. **使用误区**：
   - 滥用 `useMemo` 缓存简单计算。
   - 依赖项缺失导致缓存结果过期。
   - 在 `useMemo` 中执行副作用。
5. **性能权衡**：
   - `useMemo` 同步执行，过于昂贵的计算会阻塞渲染，建议将超大型计算放在 `useEffect` 中异步执行。
   - 缓存的结果会占用内存，需避免缓存过大的数据（如百万级数组）。...', 'aac29662-babe-4c96-8f61-0a16830155d4', 'true', '2025-12-19 15:19:02.89974+00', '2025-12-22 02:38:56.145294+00'), ('9cda2038-f2bf-414c-8a29-d825dad5c556', '异步错误处理（useErrorBoundary）', 'React 内置的错误边界仅支持类组件，且无法直接捕获异步错误（如 `fetch` 请求、`setTimeout` 回调中的错误）。`react-error-boundary` 是社区主流的错误处理库，提供了函数组件友好的 API（如 `useErrorBoundary` Hook），支持捕获异步错误、自定义降级 UI 等功能，解决了原生错误边界的局限性。

# 1. 安装 react-error-boundary
```bash
npm install react-error-boundary

yarn add react-error-boundary
```

# 2. 核心 API 介绍
## 2.1 ErrorBoundary 组件（函数组件版）
替代原生类组件错误边界，支持通过 `fallback` 属性自定义降级 UI，通过 `onError` 回调记录错误。

## 2.2 useErrorBoundary Hook
用于在函数组件内部手动触发错误边界，捕获异步错误或事件处理错误。

## 2.3 FallbackComponent 组件
可复用的降级 UI 组件，接收 `error`、`resetErrorBoundary` 等 props，实现错误展示和恢复逻辑。

# 3. 基础使用：捕获渲染错误
```javascript
import { ErrorBoundary } from ''react-error-boundary'';

// 自定义降级 UI 组件
function ErrorFallback({ error, resetErrorBoundary }) {
  return (
    <div role="alert">
      <h2>出错了！</h2>
      <p>{error.message}</p>
      <button onClick={resetErrorBoundary}>重试</button>
    </div>
  );
}

// 可能抛出渲染错误的组件
function BuggyComponent() {
  // 模拟渲染错误
  throw new Error(''组件渲染失败！'');
  return <div>正常内容</div>;
}

function App() {
  return (
    <ErrorBoundary
      FallbackComponent={ErrorFallback}
      onError={(error, info) => {
        // 错误上报逻辑
        console.error(''捕获到错误：'', error, info);
      }}
    >
      <BuggyComponent />
    </ErrorBoundary>
  );
}
```

# 4. 捕获异步错误（useErrorBoundary Hook）
原生错误边界无法捕获异步错误，`useErrorBoundary` 提供了 `showBoundary` 方法，可手动将异步错误传递给错误边界。

## 4.1 示例：捕获数据请求错误
```javascript
import { useErrorBoundary } from ''react-error-boundary'';
import { useState, useEffect } from ''react'';

function DataFetchingComponent() {
  const [data, setData] = useState(null);
  // 获取手动触发错误边界的方法
  const { showBoundary } = useErrorBoundary();

  useEffect(() => {
    // 异步请求数据
    const fetchData = async () => {
      try {
        const res = await fetch(''/api/invalid-endpoint''); // 无效接口，模拟错误
        if (!res.ok) {
          throw new Error(`请求失败：${res.status}`);
        }
        const data = await res.json();
        setData(data);
      } catch (error) {
        // 手动触发错误边界，显示降级 UI
        showBoundary(error);
      }
    };

    fetchData();
  }, [showBoundary]);

  if (!data) {
    return <div>加载中...</div>;
  }

  return <div>数据：{JSON.stringify(data)}</div>;
}

// 包裹错误边界
function App() {
  return (
    <ErrorBoundary FallbackComponent={ErrorFallback}>
      <DataFetchingComponent />
    </ErrorBoundary>
  );
}
```

## 4.2 示例：捕获事件处理错误
```javascript
import { useErrorBoundary } from ''react-error-boundary'';

function ButtonComponent() {
  const { showBoundary } = useErrorBoundary();

  const handleClick = () => {
    try {
      // 模拟事件处理错误
      riskyFunction();
    } catch (error) {
      // 手动触发错误边界
      showBoundary(error);
    }
  };

  return <button onClick={handleClick}>点击触发可能的错误</button>;
}
```

# 5. 高级用法
## 5.1 重置错误状态
`ErrorBoundary` 组件会传递 `resetErrorBoundary` 方法给 `FallbackComponent`，用于重置错误状态，重新渲染子组件：
```javascript
function ErrorFallback({ error, resetErrorBoundary }) {
  return (
    <div>
      <p>{error.message}</p>
      <button onClick={resetErrorBoundary}>重新加载</button>
    </div>
  );
}
```

## 5.2 错误边界重试时传递参数
若需在重置错误时传递参数（如重新请求的 ID），可通过 `resetKeys` 属性实现：
```javascript
function App() {
  const [postId, setPostId] = useState(1);

  return (
    <ErrorBoundary
      FallbackComponent={ErrorFallback}
      resetKeys={[postId]} // 当 postId 变化时，自动重置错误边界
    >
      <PostComponent postId={postId} />
      <button onClick={() => setPostId(postId + 1)}>加载下一篇</button>
    </ErrorBoundary>
  );
}
```

## 5.3 全局错误监听
结合 `react-error-boundary` 和全局错误监听，实现全量错误捕获：
```javascript
import { ErrorBoundary } from ''react-error-boundary'';

// 全局监听未捕获的错误
window.addEventListener(''error'', (event) => {
  console.error(''全局捕获的同步错误：'', event.error);
});

// 全局监听未处理的 Promise 错误
window.addEventListener(''unhandledrejection'', (event) => {
  console.error(''全局捕获的异步错误：'', event.reason);
});

function App() {
  return (
    <ErrorBoundary
      FallbackComponent={GlobalErrorFallback}
      onError={(error, info) => {
        // 上报到错误监控平台
        logErrorToService(error, info);
      }}
    >
      <MainApp />
    </ErrorBoundary>
  );
}
```

# 6. 最佳实践
1. **区分错误类型**：
   - 渲染错误：直接用 `ErrorBoundary` 包裹；
   - 异步/事件错误：用 `useErrorBoundary` 手动触发；
2. **分级错误处理**：
   - 页面级错误边界：处理单个页面的错误；
   - 组件级错误边界：处理关键组件（如表单、列表）的错误；
   - 全局错误边界：兜底捕获未处理的错误；
3. **友好的降级体验**：
   - 提供清晰的错误提示（避免技术术语）；
   - 提供恢复操作（重试、刷新、返回首页）；
   - 生产环境隐藏错误栈，开发环境显示详细信息；
4. **错误日志标准化**：
   - 统一错误上报格式（包含错误信息、组件栈、用户信息、时间戳）；
   - 区分前端错误和后端错误（如 API 404/500）；

# 7. 原生错误边界 vs react-error-boundary
| 特性 | 原生错误边界 | react-error-boundary |
|------|--------------|----------------------|
| 组件类型 | 仅支持类组件 | 支持函数组件/类组件 |
| 异步错误捕获 | 不支持 | 支持（通过 useErrorBoundary） |
| 事件处理错误捕获 | 不支持 | 支持（通过 useErrorBoundary） |
| 自定义降级 UI | 需手动实现 | 内置 FallbackComponent 支持 |
| 错误重置 | 需手动实现 | 内置 resetErrorBoundary 方法 |
| 错误上报 | 需手动实现 | 内置 onError 回调 |
| 易用性 | 低（类组件、API 繁琐） | 高（Hook 化、API 简洁） |
', 'a02f0182-c167-4bad-9395-1aa29e0a493f', 'true', '2025-12-22 03:17:28.840032+00', '2025-12-23 09:54:27.06283+00'), ('9f5a67e8-a673-4edc-8867-9b60d6ceb531', '组件的生命周期', '组件的生命周期指组件从**创建**、**更新**到**销毁**的整个过程，React 为不同阶段提供了对应的钩子函数，让开发者可以在特定时机执行逻辑。类组件拥有明确的生命周期划分，而函数组件通过 **Hooks** 实现类似的生命周期能力。

# 1. 类组件的生命周期
类组件的生命周期分为 **3 个阶段**：**挂载阶段**、**更新阶段**、**卸载阶段**，React 16.3 之后对部分生命周期钩子进行了调整（废弃了 `componentWillMount`、`componentWillReceiveProps` 等）。

## 1.1 挂载阶段（组件首次渲染到 DOM）
组件第一次被创建并插入 DOM 树的阶段，该阶段只执行一次。
- **constructor()**：组件构造函数，初始化 `this.state` 和绑定事件处理函数。
  ```jsx
  constructor(props) {
    super(props);
    this.state = { count: 0 };
    this.handleClick = this.handleClick.bind(this);
  }
  ```
- **static getDerivedStateFromProps(props, state)**：静态方法，根据 props 更新 state，返回新的 state 对象（避免直接修改 state）。
- **render()**：必须实现的方法，返回组件的 JSX 结构，**纯函数（无副作用）**，不允许调用 setState。
- **componentDidMount()**：组件挂载完成后执行，可执行 DOM 操作、数据请求、订阅事件等副作用逻辑。
  ```jsx
  componentDidMount() {
    // 数据请求
    fetch(''/api/data'').then(res => res.json()).then(data => this.setState({ data }));
    // 订阅事件
    this.timer = setInterval(() => this.setState({ count: this.state.count + 1 }), 1000);
  }
  ```

## 1.2 更新阶段（组件状态或 props 变化）
当组件的 `props` 或 `state` 发生变化时触发，会重复执行多次。
- **static getDerivedStateFromProps(props, state)**：挂载阶段也会执行，更新阶段同样会根据 props 更新 state。
- **shouldComponentUpdate(nextProps, nextState)**：返回布尔值，决定组件是否需要重新渲染。返回 `false` 则跳过后续的 render 和更新钩子，常用于性能优化。
- **render()**：重新渲染组件 JSX 结构。
- **getSnapshotBeforeUpdate(prevProps, prevState)**：在 DOM 更新之前执行，返回一个快照值，传递给 `componentDidUpdate`。
- **componentDidUpdate(prevProps, prevState, snapshot)**：组件更新完成后执行，可根据前后 props/state 的变化执行 DOM 操作或数据请求（注意：需要加条件判断，避免无限循环）。
  ```jsx
  componentDidUpdate(prevProps) {
    // 当 props.id 变化时重新请求数据
    if (this.props.id !== prevProps.id) {
      fetch(`/api/data/${this.props.id}`).then(res => res.json()).then(data => this.setState({ data }));
    }
  }
  ```

## 1.3 卸载阶段（组件从 DOM 移除）
组件被销毁并从 DOM 树中移除的阶段，该阶段只执行一次。
- **componentWillUnmount()**：组件卸载前执行，用于清理副作用，如清除定时器、取消订阅、取消网络请求等。
  ```jsx
  componentWillUnmount() {
    clearInterval(this.timer); // 清除定时器
  }
  ```

## 1.4 类组件生命周期流程图
```
挂载阶段：constructor → getDerivedStateFromProps → render → componentDidMount

更新阶段：getDerivedStateFromProps → shouldComponentUpdate → render → getSnapshotBeforeUpdate → componentDidUpdate

卸载阶段：componentWillUnmount
```

# 2. 函数组件的副作用（Hooks 实现生命周期）
函数组件没有类组件的生命周期钩子，而是通过 **useEffect Hook** 统一处理**副作用**（即所有不在渲染过程中执行的逻辑，如数据请求、DOM 操作、订阅、定时器等）。`useEffect` 可以模拟类组件的多个生命周期钩子。

## 2.1 useEffect 基本用法
```jsx
import { useEffect } from ''react'';

function MyComponent() {
  useEffect(() => {
    // 副作用逻辑：如数据请求、DOM 操作
    console.log(''组件挂载/更新'');

    // 清理函数：组件卸载或依赖变化时执行
    return () => {
      console.log(''组件卸载/依赖变化'');
    };
  }, [依赖数组]); // 依赖数组：控制 useEffect 的执行时机
}
```

## 2.2 useEffect 模拟类组件生命周期
| 类组件生命周期钩子 | 函数组件 useEffect 实现方式 | 适用场景 |
|--------------------|-----------------------------|----------|
| componentDidMount | useEffect(() => { ... }, []) | 组件挂载后执行一次，如初始化数据请求、订阅事件 |
| componentDidUpdate | useEffect(() => { ... }, [dep1, dep2]) | 依赖项（dep1/dep2）变化时执行，如 props 变化后重新请求数据 |
| componentWillUnmount | useEffect(() => { return () => { ... } }, []) | 清理副作用，如清除定时器、取消订阅 |

## 2.3 示例：useEffect 模拟生命周期
```jsx
import { useState, useEffect } from ''react'';

function Timer() {
  const [count, setCount] = useState(0);

  // 模拟 componentDidMount + componentWillUnmount
  useEffect(() => {
    const timer = setInterval(() => {
      setCount(prevCount => prevCount + 1);
    }, 1000);
    // 清理函数：模拟 componentWillUnmount
    return () => clearInterval(timer);
  }, []); // 空依赖数组：只执行一次

  // 模拟 componentDidUpdate
  useEffect(() => {
    console.log(`count 更新为：${count}`);
  }, [count]); // count 变化时执行

  return <h1>Count: {count}</h1>;
}
```

# 3. 核心区别总结
- 类组件：生命周期划分清晰，钩子函数各司其职，但易出现逻辑分散、嵌套复杂的问题。
- 函数组件：通过 useEffect 统一管理副作用，逻辑更聚合，可通过依赖数组精准控制执行时机，配合自定义 Hooks 可实现逻辑复用。', '16d6f496-f7f3-422b-baf9-c5f027a71aaa', 'true', '2025-12-19 10:04:12.060982+00', '2025-12-19 10:04:12.060982+00'), ('a2fcff48-e668-46d6-ac56-2f8e30cf1d48', 'Hooks 常见陷阱', 'React Hooks 虽简化了状态管理和副作用处理，但因对执行机制、依赖规则的理解不足，容易陷入各类陷阱。以下是最常见的三类陷阱及解决方案：

# 1. 闭包问题
## 1.1 陷阱表现
Hooks 依赖 JavaScript 闭包特性，若在异步操作（定时器、网络请求）中访问组件状态/属性，可能捕获到旧的闭包值，导致获取的状态不是最新的。

## 1.2 示例：定时器中获取旧状态
```jsx
function Counter() {
  const [count, setCount] = useState(0);

  useEffect(() => {
    const timer = setInterval(() => {
      // 每次执行都打印初始值 0，而非最新count
      console.log(''当前count：'', count);
    }, 1000);
    return () => clearInterval(timer);
  }, []); // 依赖项为空，闭包捕获初始count=0

  return <button onClick={() => setCount(prev => prev + 1)}>count: {count}</button>;
}
```

## 1.3 根本原因
`useEffect` 依赖项为空时，仅在组件挂载时执行一次，内部定时器的闭包捕获了挂载时的 `count`（值为 0），后续 `count` 更新不会触发 `useEffect` 重新执行，定时器始终访问旧值。

## 1.4 解决方案
1. **添加依赖项**：将使用的状态加入 `useEffect` 依赖数组，依赖变化时重新创建闭包。
   ```jsx
   useEffect(() => {
     const timer = setInterval(() => {
       console.log(''当前count：'', count);
     }, 1000);
     return () => clearInterval(timer);
   }, [count]); // 依赖count，更新时重新执行
   ```

2. **使用 useRef 保存最新值**：通过 `ref` 同步最新状态（`ref.current` 不受闭包影响）。
   ```jsx
   function Counter() {
     const [count, setCount] = useState(0);
     const countRef = useRef(count);
     // 同步最新count到ref
     useEffect(() => {
       countRef.current = count;
     }, [count]);

     useEffect(() => {
       const timer = setInterval(() => {
         // 访问ref.current获取最新值
         console.log(''当前count：'', countRef.current);
       }, 1000);
       return () => clearInterval(timer);
     }, []);

     return <button onClick={() => setCount(prev => prev + 1)}>count: {count}</button>;
   }
   ```

3. **函数式更新**：更新状态时使用函数式写法，直接获取最新状态（适用于更新逻辑）。
   ```jsx
   setCount(prev => {
     console.log(''最新count：'', prev); // 始终获取最新值
     return prev + 1;
   });
   ```

# 2. 依赖项缺失
## 2.1 陷阱表现
使用 `useEffect`、`useCallback`、`useMemo` 时，未将内部使用的所有状态/属性/函数加入依赖数组，导致 Hooks 执行逻辑与预期不符（如副作用不触发、获取旧值）。

## 2.2 示例：依赖项缺失导致副作用不更新
```jsx
function UserProfile({ userId }) {
  const [user, setUser] = useState(null);

  const fetchUser = async () => {
    const res = await fetch(`https://api.example.com/user/${userId}`);
    const data = await res.json();
    setUser(data);
  };

  useEffect(() => {
    fetchUser();
    // 依赖项仅加了fetchUser，未加userId → userId变化时，fetchUser闭包捕获旧userId
  }, [fetchUser]);

  return <div>{user?.name || ''加载中...''}</div>;
}
```

## 2.3 根本原因
`fetchUser` 内部依赖 `userId`，但 `useEffect` 仅依赖 `fetchUser`；每次 `userId` 变化时，组件重新渲染会创建新的 `fetchUser` 函数，触发 `useEffect` 执行，但 `fetchUser` 内部的 `userId` 是旧值（闭包捕获），导致请求的还是旧用户数据。

## 2.4 解决方案
1. **完整声明依赖项**：将 Hooks 内部使用的所有变量、函数加入依赖数组（可通过 ESLint 规则 `react-hooks/exhaustive-deps` 自动检查）。
   ```jsx
   useEffect(() => {
     fetchUser();
   }, [fetchUser, userId]); // 补充userId依赖
   ```

2. **优化函数依赖**：使用 `useCallback` 缓存函数，减少不必要的重执行，同时明确函数依赖。
   ```jsx
   const fetchUser = useCallback(async () => {
     const res = await fetch(`https://api.example.com/user/${userId}`);
     const data = await res.json();
     setUser(data);
   }, [userId]); // 函数依赖userId，变化时重新创建

   useEffect(() => {
     fetchUser();
   }, [fetchUser]); // 仅依赖缓存后的fetchUser
   ```

3. **内联函数到 Hooks 中**：将函数直接写在 `useEffect` 内部，避免外部函数的依赖问题（适用于简单逻辑）。
   ```jsx
   useEffect(() => {
     const fetchUser = async () => {
       const res = await fetch(`https://api.example.com/user/${userId}`);
       const data = await res.json();
       setUser(data);
     };
     fetchUser();
   }, [userId]); // 仅依赖userId
   ```

# 3. 无限循环
## 3.1 陷阱表现
组件渲染后触发副作用，副作用中更新状态，状态更新又触发副作用，形成无限循环（组件反复渲染，导致性能崩溃）。

## 3.2 示例1：useEffect 中更新未加入依赖的状态
```jsx
function ListComponent() {
  const [list, setList] = useState([]);

  useEffect(() => {
    // 模拟请求数据
    const newList = [1, 2, 3];
    setList(newList); // 更新list，触发组件重渲染
    // 依赖项为空 → 仅挂载时执行一次？不！list是新数组（引用变化），但useEffect依赖为空，不会重复执行？
    // 错误示例：若依赖项包含list，则会无限循环
  }, [list]); // ❌ 依赖list，setList更新list → 触发useEffect → 再次setList → 无限循环
}
```

## 3.3 示例2：useState 直接更新对象/数组（引用变化）
```jsx
function FormComponent() {
  const [form, setForm] = useState({ name: '''', age: 0 });

  useEffect(() => {
    // 模拟验证表单
    console.log(''表单变化：'', form);
  }, [form]); // 依赖form对象

  const handleChange = () => {
    // ❌ 每次创建新对象，form引用变化 → 触发useEffect → 若内部有更新逻辑则可能循环
    setForm({ ...form, name: ''张三'' });
  };

  return <button onClick={handleChange}>修改表单</button>;
}
```

## 3.4 根本原因
1. 副作用依赖项中包含被更新的状态，状态更新后依赖项变化，触发副作用再次执行，形成闭环；
2. 对象/数组的引用变化（即使内容相同），被 Hooks 判定为依赖变化，触发重复执行。

## 3.5 解决方案
1. **移除不必要的依赖项**：若副作用仅需执行一次（如初始化请求），依赖项设为空数组，避免依赖状态。
   ```jsx
   useEffect(() => {
     const newList = [1, 2, 3];
     setList(newList);
   }, []); // ✅ 仅挂载时执行，无循环
   ```

2. **使用函数式更新**：更新状态时依赖旧状态，避免直接依赖新状态。
   ```jsx
   setForm(prev => ({ ...prev, name: ''张三'' })); // 不依赖外部form，仅依赖prev
   ```

3. **缓存对象/数组（useMemo/useCallback）**：对复杂类型依赖项进行缓存，避免不必要的引用变化。
   ```jsx
   const form = useMemo(() => ({ name: '''', age: 0 }), []); // 缓存表单初始值
   ```

4. **依赖项精准化**：仅依赖必要的属性，而非整个对象/数组。
   ```jsx
   useEffect(() => {
     console.log(''姓名变化：'', form.name);
   }, [form.name]); // ✅ 仅依赖name，而非整个form对象
   ```

5. **避免在副作用中无条件更新状态**：仅在满足特定条件时更新状态（如数据未加载时）。
   ```jsx
   useEffect(() => {
     if (list.length === 0) { // 仅初始为空时更新
       const newList = [1, 2, 3];
       setList(newList);
     }
   }, [list]);
   ```

# 4. 陷阱规避总结
1. **启用 ESLint 规则**：开启 `react-hooks/rules-of-hooks` 和 `react-hooks/exhaustive-deps`，强制遵守 Hooks 规则，检测缺失的依赖项；
2. **理解闭包特性**：明确异步操作中闭包对状态的捕获机制，使用 `ref` 或函数式更新获取最新值；
3. **依赖项最小化**：仅将必要的变量/函数加入依赖数组，避免依赖复杂对象/数组；
4. **调试工具辅助**：使用 React DevTools 查看 Hooks 依赖变化，定位无限循环或闭包问题。', '9e07a04e-b6bb-488a-9725-08821605cfbc', 'true', '2025-12-22 02:22:56.181921+00', '2025-12-23 02:05:10.02051+00'), ('aa7252fc-8035-472f-b5a6-e9d639c15a33', '协调（Reconciliation）与 Fiber 架构', '# 1. 什么是协调（Reconciliation）
协调是 React 将**虚拟 DOM 差异转换为真实 DOM 更新**的全过程，包含两个核心步骤：
1. **Diff 算法**：对比新旧虚拟 DOM 树，找出差异（“找不同”）；
2. **Commit 阶段**：将差异批量应用到真实 DOM 中（“打补丁”）。

在 React 16 之前，协调过程是**同步且不可中断**的：一旦开始协调，必须执行到底，若组件树庞大，会阻塞浏览器主线程（导致页面卡顿、交互无响应）。

## 1.1 同步协调的问题
- 浏览器主线程（JS 执行、DOM 渲染、事件处理）是单线程的；
- 若协调过程耗时超过 16ms（浏览器刷新率 60fps，每帧约 16ms），会导致帧丢失，页面出现卡顿；
- 例如：渲染 1000 个列表项的组件，协调过程耗时 100ms，期间用户点击按钮无响应，体验极差。

# 2. Fiber 架构：React 16 的核心重构
为解决同步协调的卡顿问题，React 16 引入 Fiber 架构，核心目标是**将协调过程从“同步不可中断”改为“异步可中断”**，允许 React 在执行耗时任务时，暂停并优先处理高优先级任务（如用户输入、动画），再继续执行低优先级任务（如组件渲染）。

## 2.1 什么是 Fiber
Fiber 有两层含义：
1. **数据结构**：Fiber 是虚拟 DOM 的升级版，是描述工作单元的 JavaScript 对象，包含节点信息、任务优先级、父子/兄弟节点引用等；
   ```javascript
   // Fiber 节点结构（简化版）
   const fiberNode = {
     type: ''div'', // 节点类型
     props: {}, // 节点属性
     stateNode: null, // 对应真实 DOM 节点
     child: null, // 子 Fiber 节点
     sibling: null, // 兄弟 Fiber 节点
     return: null, // 父 Fiber 节点
     priority: 0, // 任务优先级
     effectTag: null, // 副作用类型（更新/删除/插入）
     nextEffect: null // 下一个有副作用的 Fiber 节点
   };
   ```
2. **执行机制**：Fiber 是一种“增量式渲染”机制，将整个协调过程拆分为多个小的工作单元（每个 Fiber 节点对应一个工作单元），可按需暂停、恢复、终止。

# 3. Fiber 架构的核心特性
## 3.1 工作单元拆分
将组件树的渲染任务拆分为单个 Fiber 节点的处理任务，每个工作单元执行时间极短（<16ms），避免阻塞主线程。

## 3.2 优先级调度
React 为不同任务分配优先级（如用户输入 > 动画 > 数据加载 > 普通渲染），优先级高的任务可中断优先级低的任务：
- 高优先级任务（如点击按钮）：立即执行，暂停当前低优先级任务；
- 低优先级任务（如列表渲染）：执行一部分后，若有高优先级任务，保存当前进度，待高优先级任务完成后继续执行。

## 3.3 双向链表遍历
Fiber 节点通过 `child`（子）、`sibling`（兄弟）、`return`（父）形成双向链表，支持：
- **深度优先遍历**：先处理子节点，再处理兄弟节点，最后回到父节点；
- **中断与恢复**：通过保存当前遍历位置，实现任务暂停后恢复。

## 3.4 副作用收集
协调过程中，React 不会立即更新真实 DOM，而是将所有需要修改的 Fiber 节点标记副作用（`effectTag`），待所有工作单元执行完成后，一次性批量更新真实 DOM（Commit 阶段），减少重排/重绘。

# 4. Fiber 架构的工作流程
Fiber 架构将协调过程分为两个阶段：**Render 阶段（可中断）** 和 **Commit 阶段（不可中断）**。

## 阶段 1：Render 阶段（异步可中断）
核心任务：遍历 Fiber 树，执行 Diff 算法，收集副作用（更新/删除/插入）。
1. **开始工作**：从根 Fiber 节点开始，创建新的 Fiber 树（WorkInProgress 树）；
2. **处理工作单元**：逐个处理 Fiber 节点（创建/更新/删除），标记副作用；
3. **检查优先级**：每处理完一个工作单元，检查是否有高优先级任务；
   - 若无：继续处理下一个工作单元；
   - 若有：暂停当前工作，保存进度，执行高优先级任务；
4. **完成 Render 阶段**：所有工作单元处理完毕后，生成副作用链表（`nextEffect`）。

## 阶段 2：Commit 阶段（同步不可中断）
核心任务：将 Render 阶段收集的副作用批量应用到真实 DOM，执行生命周期钩子（如 `componentDidMount`/`useEffect`）。
1. **Before Mutations**：执行 DOM 更新前的操作（如读取 DOM 布局）；
2. **Mutations**：根据副作用链表更新真实 DOM（插入/删除/修改节点）；
3. **Layout**：执行 DOM 更新后的操作（如调用 `useLayoutEffect`、更新组件引用）。

# 5. Fiber 架构的价值
- **解决卡顿问题**：异步可中断渲染避免了长时间阻塞主线程，提升页面流畅度；
- **支持优先级调度**：优先处理用户交互等关键任务，优化用户体验；
- **为新特性铺路**：是 React 18 并发渲染、Suspense、useTransition 等特性的基础；
- **更高效的内存管理**：Fiber 节点的双向链表结构减少了内存占用，提升遍历效率。

# 6. 常见疑问：Fiber 与虚拟 DOM 的关系
- 虚拟 DOM 是“数据描述”（What），Fiber 是“执行机制”（How）；
- Fiber 节点包含了虚拟 DOM 的信息（类型、属性），同时增加了执行相关的元数据（优先级、副作用）；
- 虚拟 DOM 是 Fiber 架构的基础，Fiber 架构优化了虚拟 DOM 的渲染过程。', '46554425-2ee6-405b-b46c-7720d50c48ec', 'true', '2025-12-22 03:14:57.55+00', '2025-12-23 09:31:38.48388+00'), ('ab8119f9-af1c-4d91-9de4-732c8d9a6ba0', '父传子——props', '在 React 组件通信中，**父传子**是最基础、最常用的通信方式，核心依赖 `props`（properties 的缩写）实现。`props` 是父组件传递给子组件的数据容器，具有只读特性，子组件只能使用不能修改。

# 1. props 基础用法
## 1.1 基本传递流程
父组件通过**标签属性**的形式传递数据，子组件通过**参数接收**并使用，步骤如下：
### （1）父组件传递数据
父组件在引用子组件时，像 HTML 标签添加属性一样，将需要传递的数据作为属性传入，支持任意 JavaScript 数据类型（字符串、数字、数组、对象、函数等）。
```jsx
// 父组件 Parent.jsx
import Child from ''./Child'';

function Parent() {
  // 父组件的数据源
  const name = ''React 组件'';
  const age = 3;
  const skills = [''组件化'', ''声明式 UI'', ''虚拟 DOM''];
  const info = { author: ''Facebook'', type: ''前端框架'' };
  const greet = () => console.log(''Hello from Parent'');

  // 传递数据：通过标签属性传递给子组件
  return (
    <div>
      <h1>父组件</h1>
      <Child 
        title={name}  // 字符串类型
        version={age} // 数字类型
        features={skills} // 数组类型
        meta={info} // 对象类型
        sayHi={greet} // 函数类型
        isPopular={true} // 布尔类型
      />
    </div>
  );
}
```

### （2）子组件接收并使用数据
- 函数组件：直接通过**函数参数**接收 `props`，无需额外处理。
- 类组件：通过 `this.props` 访问父组件传递的数据。

```jsx
// 子组件 Child.jsx（函数组件，推荐）
function Child(props) {
  // 直接通过 props.属性名 使用数据
  return (
    <div>
      <h2>子组件接收的内容：</h2>
      <p>框架名称：{props.title}</p>
      <p>版本（简化）：{props.version}</p>
      <p>核心特性：{props.features.join(''、'')}</p>
      <p>作者：{props.meta.author}</p>
      <p>是否流行：{props.isPopular ? ''是'' : ''否''}</p>
      <button onClick={props.sayHi}>调用父组件函数</button>
    </div>
  );
}

// 子组件 Child.jsx（类组件，兼容老项目）
import React from ''react'';
class Child extends React.Component {
  render() {
    // 通过 this.props.属性名 使用数据
    return (
      <div>
        <p>框架名称：{this.props.title}</p>
        <button onClick={this.props.sayHi}>调用父组件函数</button>
      </div>
    );
  }
}
```

## 1.2 props 默认值
当父组件未传递某个 props 时，子组件可通过 `defaultProps`（类组件）或**函数参数默认值**（函数组件）设置默认值，避免数据缺失导致报错。

### （1）函数组件设置默认值（推荐）
```jsx
// 方式1：函数参数默认值（简洁直观）
function Child(props = { title: ''默认框架'', version: 1 }) {
  return <p>框架名称：{props.title}</p>;
}

// 方式2：通过 defaultProps 属性（兼容老写法）
function Child(props) {
  return <p>框架名称：{props.title}</p>;
}
Child.defaultProps = {
  title: ''默认框架'',
  version: 1
};
```

### （2）类组件设置默认值
```jsx
class Child extends React.Component {
  render() {
    return <p>框架名称：{this.props.title}</p>;
  }
}
// 类组件通过静态属性 defaultProps 设置默认值
Child.defaultProps = {
  title: ''默认框架'',
  version: 1
};
```

## 1.3 解构赋值简化 props 使用
当 props 数量较多时，可通过 ES6 解构赋值简化代码，直接提取需要的属性，提高可读性。
```jsx
// 函数组件解构（推荐）
function Child({ title, version, features = [] }) {
  return (
    <div>
      <p>框架名称：{title}</p>
      <p>核心特性：{features.join(''、'')}</p>
    </div>
  );
}

// 类组件解构
class Child extends React.Component {
  render() {
    const { title, version } = this.props; // 解构 this.props
    return <p>框架名称：{title}，版本：{version}</p>;
  }
}
```

# 2. props 只读特性（核心规则）
React 明确规定：**props 是只读的（read-only），子组件绝对不能修改 props 的值**。

## 2.1 为什么 props 是只读的？
- 组件设计原则：React 组件本质是“纯函数”，输入（props）决定输出（UI），修改输入会导致组件行为不可预测，违背纯函数特性。
- 数据流向：React 是“单向数据流”，数据只能从父组件向下传递到子组件，子组件若需修改数据，必须通知父组件通过自身状态更新，再重新传递给子组件。

## 2.2 错误示例（禁止修改 props）
```jsx
function Child(props) {
  // 错误：直接修改 props 的属性值
  props.version = 4; // 报错：Cannot assign to read only property ''version'' of object ''#<Object>''
  
  // 错误：尝试重新赋值 props
  props = { title: ''修改后的框架'' }; // 虽然不报错，但破坏单向数据流，导致逻辑混乱
  
  return <p>版本：{props.version}</p>;
}
```

## 2.3 正确做法（需修改数据时）
若子组件需要基于 props 产生“可变数据”，应将 props 作为初始值，存入组件自身的状态（`useState` 或 `this.state`），再修改状态：
```jsx
function Child({ initialVersion = 1 }) {
  // 将 props 作为初始值，存入组件自身状态
  const [version, setVersion] = useState(initialVersion);
  
  // 正确：修改自身状态，而非 props
  const handleUpdate = () => setVersion(prev => prev + 1);
  
  return (
    <div>
      <p>当前版本：{version}</p>
      <button onClick={handleUpdate}>升级版本</button>
    </div>
  );
}
```

# 3. 核心总结
1. **传递规则**：父组件通过标签属性传值，子组件通过 `props`（函数组件）或 `this.props`（类组件）接收。
2. **支持类型**：任意 JavaScript 类型（字符串、数字、数组、对象、函数等）。
3. **只读特性**：props 不可修改，子组件需修改数据时，应基于 props 初始化自身状态。
4. **默认值**：函数组件用参数默认值，类组件用 `defaultProps`，避免数据缺失。', '803ada09-ee46-463c-b7f3-403560bfc20b', 'true', '2025-12-19 10:42:47.60002+00', '2025-12-19 10:42:47.60002+00'), ('ae5d4a7d-fa74-4f81-a069-542a6fa08a31', 'Axios 封装', '# 1. Axios 核心价值与封装意义
Axios 是 React 项目中最常用的 HTTP 客户端，支持 Promise API、拦截请求/响应、取消请求、自动转换 JSON 数据等核心功能。直接使用 Axios 会导致代码冗余（如重复配置请求头、错误处理），封装后可实现：
- 统一请求配置（基础路径、超时时间、请求头）；
- 全局拦截器（添加 Token、处理 Token 过期、统一错误提示）；
- 取消重复请求（避免同一接口多次触发）；
- 统一错误处理（网络错误、业务错误、状态码错误）；
- 类型安全（TypeScript 类型定义，适配接口返回格式）。

# 2. 基础环境搭建
## 2.1 安装依赖
```bash
npm install axios # 核心依赖
npm install -D @types/axios # TypeScript 类型（可选）
```

## 2.2 目录结构设计
```
src/
├── api/
│   ├── index.ts        # Axios 实例封装
│   ├── request.ts      # 请求工具函数（get/post/put/delete）
│   ├── cancel.ts       # 取消请求相关工具
│   └── modules/        # 按业务模块拆分接口（如 user.ts、goods.ts）
└── utils/
    └── toast.ts        # 全局提示工具（如 AntD Message）
```

# 3. 核心封装实现
## 3.1 步骤 1：创建 Axios 实例（api/index.ts）
配置基础路径、超时时间、默认请求头，创建可复用的 Axios 实例：
```typescript
import axios, { AxiosInstance, AxiosRequestConfig, AxiosResponse } from ''axios'';
import { handleRequestInterceptor, handleResponseInterceptor } from ''./interceptors'';
import { setupCancelToken } from ''./cancel'';

// 创建 Axios 实例
const service: AxiosInstance = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || ''/api'', // 基础路径（从环境变量读取）
  timeout: 10000, // 超时时间（10s）
  headers: {
    ''Content-Type'': ''application/json;charset=utf-8'', // 默认请求头
  },
  withCredentials: true, // 允许跨域携带 Cookie（根据业务需求配置）
});

// 注册请求/响应拦截器
handleRequestInterceptor(service);
// 注册取消请求逻辑（在请求拦截器后执行）
setupCancelToken(service);
// 注册响应拦截器
handleResponseInterceptor(service);

export default service;
```

## 3.2 步骤 2：实现拦截器（api/interceptors.ts）
拦截请求添加 Token、处理响应错误、统一业务逻辑：
```typescript
import { AxiosInstance, AxiosRequestConfig, AxiosResponse, AxiosError } from ''axios'';
import { getToken, removeToken } from ''@/utils/auth''; // Token 存储工具（如 localStorage）
import { toastError, toastWarning } from ''@/utils/toast''; // 全局提示（如 AntD Message.error）
import router from ''@/router''; // 路由实例（React Router）

// 业务响应类型定义（适配后端返回格式）
interface ApiResponse<T = any> {
  code: number; // 状态码（200 成功，其他失败）
  message: string; // 提示信息
  data: T; // 响应数据
}

/**
 * 请求拦截器：添加 Token、设置请求头等
 */
export const handleRequestInterceptor = (service: AxiosInstance) => {
  service.interceptors.request.use(
    (config: AxiosRequestConfig) => {
      // 1. 添加 Token（如登录后存储在 localStorage 中的 Token）
      const token = getToken();
      if (token && config.headers) {
        config.headers.Authorization = `Bearer ${token}`;
      }

      // 2. 处理 GET 请求参数序列化（可选，Axios 已默认处理）
      if (config.method?.toUpperCase() === ''GET'' && config.params) {
        config.params = { ...config.params, _t: Date.now() }; // 添加时间戳防缓存
      }

      return config;
    },
    (error: AxiosError) => {
      // 请求发送前的错误（如参数格式错误）
      console.error(''请求拦截器错误：'', error);
      return Promise.reject(error);
    }
  );
};

/**
 * 响应拦截器：统一错误处理、解析业务数据
 */
export const handleResponseInterceptor = (service: AxiosInstance) => {
  service.interceptors.response.use(
    (response: AxiosResponse<ApiResponse>) => {
      const res = response.data;

      // 1. 业务成功（根据后端状态码调整，如 200/0 为成功）
      if (res.code === 200 || res.code === 0) {
        return res.data; // 直接返回 data 层，简化业务组件使用
      }

      // 2. 业务失败（如参数错误、权限不足）
      toastWarning(res.message || ''操作失败'');
      return Promise.reject(res);
    },
    (error: AxiosError) => {
      console.error(''响应拦截器错误：'', error);
      const response = error.response;

      // 3. 网络错误/超时错误
      if (!response) {
        toastError(''网络异常，请检查网络连接'');
        return Promise.reject(error);
      }

      // 4. HTTP 状态码错误（4xx/5xx）
      const status = response.status;
      switch (status) {
        case 401: // 未授权（Token 过期/未登录）
          toastError(''登录已过期，请重新登录'');
          removeToken(); // 清除无效 Token
          router.push(''/login''); // 跳转到登录页
          break;
        case 403: // 权限不足
          toastError(''暂无权限操作'');
          break;
        case 404: // 接口不存在
          toastError(''请求资源不存在'');
          break;
        case 500: // 服务器错误
          toastError(''服务器内部错误，请稍后重试'');
          break;
        default:
          toastError(`请求失败（${status}）`);
      }

      return Promise.reject(error);
    }
  );
};
```

## 3.3 步骤 3：取消请求实现（api/cancel.ts）
避免重复请求（如快速点击按钮触发多次同一接口），支持单个/全部取消：
```typescript
import { AxiosInstance, AxiosRequestConfig } from ''axios'';
import { v4 as uuidv4 } from ''uuid''; // 生成唯一标识（需安装：npm install uuid @types/uuid）

// 存储取消请求的控制器（key: 请求标识，value: AbortController）
const cancelControllerMap = new Map<string, AbortController>();

/**
 * 生成请求唯一标识（基于 URL + 方法 + 参数）
 */
const generateRequestKey = (config: AxiosRequestConfig) => {
  const { url, method, params, data } = config;
  return `${method?.toUpperCase()}-${url}-${JSON.stringify(params || {})}-${JSON.stringify(data || {})}`;
};

/**
 * 注册取消请求逻辑（在请求拦截器中添加）
 */
export const setupCancelToken = (service: AxiosInstance) => {
  service.interceptors.request.use((config) => {
    // 1. 生成请求标识
    const requestKey = generateRequestKey(config);

    // 2. 取消之前的重复请求
    if (cancelControllerMap.has(requestKey)) {
      const prevController = cancelControllerMap.get(requestKey);
      prevController?.abort(''取消重复请求'');
      cancelControllerMap.delete(requestKey);
    }

    // 3. 创建新的 AbortController（Axios 0.22+ 推荐使用，替代 CancelToken）
    const controller = new AbortController();
    config.signal = controller.signal;

    // 4. 存储控制器
    cancelControllerMap.set(requestKey, controller);

    return config;
  });

  // 响应完成后移除控制器
  service.interceptors.response.use(
    (response) => {
      const requestKey = generateRequestKey(response.config);
      cancelControllerMap.delete(requestKey);
      return response;
    },
    (error) => {
      // 取消请求的错误不提示
      if (error.name === ''CanceledError'') {
        console.log(''请求已取消：'', error.message);
        return Promise.reject(new Error(''请求已取消''));
      }
      return Promise.reject(error);
    }
  );
};

/**
 * 取消指定请求（如页面卸载时取消未完成的请求）
 * @param config 请求配置（如 { url: ''/api/user'', method: ''get'' }）
 */
export const cancelRequest = (config: AxiosRequestConfig) => {
  const requestKey = generateRequestKey(config);
  if (cancelControllerMap.has(requestKey)) {
    const controller = cancelControllerMap.get(requestKey);
    controller?.abort();
    cancelControllerMap.delete(requestKey);
  }
};

/**
 * 取消所有未完成的请求
 */
export const cancelAllRequests = () => {
  cancelControllerMap.forEach((controller) => {
    controller.abort(''取消所有请求'');
  });
  cancelControllerMap.clear();
};
```

## 3.4 步骤 4：封装请求工具函数（api/request.ts）
统一封装 get/post/put/delete 方法，简化接口调用：
```typescript
import service from ''./index'';
import { AxiosRequestConfig } from ''axios'';

/**
 * GET 请求
 * @param url 接口地址
 * @param params 请求参数（拼接在 URL 上）
 * @param config 额外请求配置
 */
export const get = <T = any>(url: string, params?: any, config?: AxiosRequestConfig): Promise<T> => {
  return service.get(url, { params, ...config });
};

/**
 * POST 请求（JSON 格式）
 * @param url 接口地址
 * @param data 请求体数据
 * @param config 额外请求配置
 */
export const post = <T = any>(url: string, data?: any, config?: AxiosRequestConfig): Promise<T> => {
  return service.post(url, data, config);
};

/**
 * PUT 请求
 * @param url 接口地址
 * @param data 请求体数据
 * @param config 额外请求配置
 */
export const put = <T = any>(url: string, data?: any, config?: AxiosRequestConfig): Promise<T> => {
  return service.put(url, data, config);
};

/**
 * DELETE 请求
 * @param url 接口地址
 * @param params 请求参数
 * @param config 额外请求配置
 */
export const del = <T = any>(url: string, params?: any, config?: AxiosRequestConfig): Promise<T> => {
  return service.delete(url, { params, ...config });
};

/**
 * 上传文件（FormData 格式）
 * @param url 接口地址
 * @param file 上传的文件
 * @param config 额外配置（如进度回调）
 */
export const upload = <T = any>(
  url: string,
  file: File,
  config?: AxiosRequestConfig
): Promise<T> => {
  const formData = new FormData();
  formData.append(''file'', file);
  return service.post(url, formData, {
    headers: { ''Content-Type'': ''multipart/form-data'' },
    ...config,
  });
};

// 导出所有请求方法
export default { get, post, put, del, upload };
```

## 3.5 步骤 5：按业务模块拆分接口（api/modules/user.ts）
```typescript
import { get, post, del } from ''../request'';

// 用户登录接口
export const login = (data: { username: string; password: string }) => {
  return post<{ token: string; userInfo: { id: number; name: string } }>(''/user/login'', data);
};

// 获取用户信息
export const getUserInfo = () => {
  return get<{ id: number; name: string; role: string }>(''/user/info'');
};

// 退出登录
export const logout = () => {
  return post(''/user/logout'');
};

// 分页获取用户列表
export const getUserList = (params: { page: number; pageSize: number; keyword?: string }) => {
  return get<{
    list: Array<{ id: number; name: string; age: number }>;
    total: number;
  }>(''/user/list'', params);
};
```

# 4. 实际使用示例
## 4.1 组件中调用接口
```tsx
import React, { useState, useEffect } from ''react'';
import { getUserList, logout } from ''@/api/modules/user'';
import { cancelRequest } from ''@/api/cancel'';
import { Button, Table, message } from ''antd'';

const UserPage = () => {
  const [userList, setUserList] = useState([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);

  // 加载用户列表
  const fetchUserList = async (page = 1, pageSize = 10) => {
    setLoading(true);
    try {
      const res = await getUserList({ page, pageSize, keyword: ''张三'' });
      setUserList(res.list);
      setTotal(res.total);
    } catch (err) {
      console.error(''获取用户列表失败：'', err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchUserList();

    // 页面卸载时取消未完成的请求
    return () => {
      cancelRequest({ url: ''/user/list'', method: ''get'' });
    };
  }, []);

  // 退出登录
  const handleLogout = async () => {
    try {
      await logout();
      message.success(''退出成功'');
      // 跳转到登录页
    } catch (err) {
      message.error(''退出失败'');
    }
  };

  return (
    <div>
      <Button type="primary" danger onClick={handleLogout} style={{ marginBottom: 16 }}>
        退出登录
      </Button>
      <Table
        loading={loading}
        dataSource={userList}
        columns={[
          { title: ''ID'', dataIndex: ''id'' },
          { title: ''姓名'', dataIndex: ''name'' },
          { title: ''年龄'', dataIndex: ''age'' },
        ]}
        pagination={{ current: 1, pageSize: 10, total }}
        rowKey="id"
      />
    </d...', 'f6ecfee0-71f1-4926-96ee-892bbcebe758', 'true', '2025-12-22 03:21:35.858233+00', '2025-12-23 14:20:53.584283+00'), ('b3d3f2bf-4973-42a0-bff7-5a34799a7096', 'React 元素渲染', '在 React 中，**元素渲染**是将我们编写的 React 元素转化为真实 DOM 节点，并挂载到页面上的过程。随着 React 版本的迭代，渲染的方式也从传统的 `ReactDOM.render` 升级为更高效的 `root.render`（React 18 引入）。

# 1. React 元素的本质
React 元素是描述页面 UI 的**不可变 JavaScript 对象**，它不是真实的 DOM 节点，而是一个轻量级的“描述符”。我们可以通过 JSX 语法快速创建 React 元素，也可以直接调用 `React.createElement` 方法生成。

示例：
```jsx
// JSX 形式（推荐）
const element = <h1>Hello, React 渲染！</h1>;

// 等价于 React.createElement 形式
const element = React.createElement(''h1'', null, ''Hello, React 渲染！'');
```
React 元素的特点是**不可变性**，一旦创建就无法修改其属性或子元素，如果需要更新 UI，只能创建一个新的 React 元素。

# 2. 传统渲染方式：ReactDOM.render
`ReactDOM.render` 是 React 18 之前的核心渲染方法，用于将 React 元素挂载到指定的 DOM 容器中。

## 2.1 基本用法
语法：
```jsx
ReactDOM.render(element, container[, callback]);
```
- `element`：要渲染的 React 元素（JSX 或 `React.createElement` 生成的对象）。
- `container`：真实 DOM 容器，用于承载 React 元素渲染后的内容。
- `callback`：可选参数，渲染完成后执行的回调函数。

示例代码：
```html
<!-- HTML 容器 -->
<div id="root"></div>

<!-- React 代码 -->
<script src="https://unpkg.com/react@17/umd/react.development.js"></script>
<script src="https://unpkg.com/react-dom@17/umd/react-dom.development.js"></script>
<script>
  const element = <h1>Hello, ReactDOM.render！</h1>;
  // 渲染到 #root 容器中
  ReactDOM.render(element, document.getElementById(''root''), () => {
    console.log(''渲染完成！'');
  });
</script>
```

## 2.2 特点与局限性
1. **特点**
    - 简单易用，直接关联 React 元素和 DOM 容器。
    - 当传入新的 React 元素时，React 会对比新旧元素的差异（**Diff 算法**），只更新变化的部分，而不是重新渲染整个 DOM。
2. **局限性**
    - 不支持 React 18 的**并发特性**（如 Suspense、自动批处理等）。
    - 无法实现更灵活的根节点配置，比如启用严格模式、并发模式等。

# 3. 现代渲染方式：root.render（React 18+）
React 18 推出了全新的**根节点 API**，通过 `createRoot` 创建根节点，再调用 `root.render` 进行渲染，这是目前推荐的渲染方式。

## 3.1 基本用法
语法：
```jsx
import { createRoot } from ''react-dom/client'';

// 1. 创建根节点
const root = createRoot(container);
// 2. 渲染 React 元素
root.render(element);
```
- `createRoot`：接收 DOM 容器作为参数，返回一个根节点对象。
- `root.render`：将 React 元素渲染到根节点对应的容器中，支持多次调用。

示例代码：
```html
<!-- HTML 容器 -->
<div id="root"></div>

<!-- React 18+ 代码 -->
<script src="https://unpkg.com/react@18/umd/react.development.js"></script>
<script src="https://unpkg.com/react-dom@18/umd/react-dom.development.js"></script>
<script>
  const element = <h1>Hello, root.render！</h1>;
  // 创建根节点
  const root = ReactDOM.createRoot(document.getElementById(''root''));
  // 渲染元素
  root.render(element);
</script>
```

## 3.2 核心优势
1. **支持并发特性**
    React 18 的并发模式允许 React 中断渲染、恢复渲染，优先处理高优先级任务（如用户输入），`root.render` 是开启这些特性的基础。
2. **自动批处理更新**
    批处理是指将多个状态更新合并为一次 DOM 更新，减少渲染次数。`root.render` 默认启用自动批处理，无论状态更新在 setTimeout、Promise 还是原生事件中，都会被合并处理。
3. **多次渲染更高效**
    当多次调用 `root.render` 时，React 会基于最新的 React 元素进行差异对比，避免重复渲染，比 `ReactDOM.render` 更高效。

# 4. 渲染更新机制
无论是 `ReactDOM.render` 还是 `root.render`，React 的渲染更新都遵循**虚拟 DOM + Diff 算法**的核心逻辑：
1. 当页面需要更新时，创建一个新的 React 元素（虚拟 DOM 节点）。
2. React 对比新旧虚拟 DOM 的差异，生成一个**差异补丁**。
3. 只将差异部分应用到真实 DOM 中，完成 UI 更新。

示例：多次渲染更新
```jsx
const root = ReactDOM.createRoot(document.getElementById(''root''));

// 第一次渲染
root.render(<h1>计数：0</h1>);

// 2 秒后更新渲染
setTimeout(() => {
  root.render(<h1>计数：1</h1>);
}, 2000);
```
在这个例子中，2 秒后 React 只会更新 `<h1>` 标签内的文本内容，而不会重新创建整个 `<h1>` 元素。

# 5. 注意事项
1. 一个 DOM 容器只能对应一个 React 根节点，多次调用 `createRoot` 会覆盖之前的根节点。
2. React 元素渲染后，会完全控制容器内的内容，容器中原有的 DOM 节点会被替换。
3. 开发环境下，`root.render` 会执行两次渲染（严格模式下），这是为了检测副作用，生产环境下只会渲染一次。', '763e50ae-d5ad-4770-b985-cb78491214e1', 'true', '2025-12-19 08:04:43.063725+00', '2025-12-19 08:55:30.503531+00'), ('bcbc4f3d-58a2-4e46-8284-de8c18b38377', '路由守卫', '**路由守卫**并非 React Router 提供的官方概念，而是开发者基于路由功能实现的“路由访问控制机制”——在用户跳转到某个路由前，验证其权限（如是否登录、是否有操作权限），根据验证结果决定允许访问、重定向到其他页面或提示无权限。

React Router v6 中实现路由守卫的核心方式是：利用组件的生命周期/渲染逻辑、`Navigate` 组件（重定向）、`useNavigate` 钩子（编程式跳转）。

# 1. 核心应用场景
1. 未登录用户访问需要授权的页面（如个人中心、后台管理），重定向到登录页；
2. 已登录用户重复访问登录页，重定向到首页；
3. 权限不足的用户访问特定页面（如普通用户访问管理员页面），提示无权限或重定向。

# 2. 实现方式
## 2.1 基础鉴权组件（通用守卫）
封装一个可复用的鉴权组件，包裹需要保护的路由组件，实现“全局守卫逻辑”：
```jsx
// components/PrivateRoute.jsx
import { Navigate } from ''react-router-dom'';

// 模拟登录状态（实际项目中从状态管理库/本地存储获取）
const isLogin = () => {
  return localStorage.getItem(''token'') !== null;
};

// 鉴权组件：children 为需要保护的组件
export default function PrivateRoute({ children }) {
  if (!isLogin()) {
    // 未登录：重定向到登录页，并记录当前路径（登录后可返回）
    return <Navigate to="/login" replace state={{ from: window.location.pathname }} />;
  }
  // 已登录：渲染受保护的组件
  return children;
}
```

## 2.2 在路由中使用鉴权组件
将需要保护的路由组件用 `PrivateRoute` 包裹：
```jsx
// App.jsx
import { BrowserRouter, Routes, Route } from ''react-router-dom'';
import PrivateRoute from ''./components/PrivateRoute'';
import Login from ''./pages/Login'';
import Dashboard from ''./pages/Dashboard''; // 需要登录才能访问

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/login" element={<Login />} />
        {/* 受保护的路由 */}
        <Route 
          path="/dashboard" 
          element={
            <PrivateRoute>
              <Dashboard />
            </PrivateRoute>
          } 
        />
      </Routes>
    </BrowserRouter>
  );
}
```

## 2.3 登录页的“回跳逻辑”
登录成功后，返回之前想要访问的页面（通过 `state` 传递的 `from` 参数）：
```jsx
// pages/Login.jsx
import { useNavigate, useLocation } from ''react-router-dom'';

export default function Login() {
  const navigate = useNavigate();
  const location = useLocation();
  // 获取之前的路径，默认值为首页
  const from = location.state?.from || ''/'';

  const handleLogin = () => {
    // 模拟登录：存储 token
    localStorage.setItem(''token'', ''fake-token-123'');
    // 跳转到之前想要访问的页面
    navigate(from, { replace: true });
  };

  return (
    <div>
      <h1>登录页</h1>
      <button onClick={handleLogin}>模拟登录</button>
    </div>
  );
}
```

## 2.4 细粒度权限控制（角色鉴权）
针对不同角色（如管理员、普通用户）设置路由访问权限：
```jsx
// components/RoleRoute.jsx
import { Navigate } from ''react-router-dom'';

// 模拟用户角色（实际从接口/本地存储获取）
const getUserRole = () => {
  return localStorage.getItem(''role'') || ''user''; // admin / user
};

// 角色鉴权组件：需要指定允许的角色
export default function RoleRoute({ allowedRoles, children }) {
  const currentRole = getUserRole();
  if (!allowedRoles.includes(currentRole)) {
    // 无权限：重定向到无权限页面或首页
    return <Navigate to="/403" replace />;
  }
  return children;
}
```

使用方式：
```jsx
<Route 
  path="/admin" 
  element={
    <PrivateRoute>
      <RoleRoute allowedRoles={[''admin'']}>
        <AdminPage />
      </RoleRoute>
    </PrivateRoute>
  } 
/>
```

## 2.5 编程式路由守卫（组件内守卫）
在组件渲染时进行权限校验（适用于单个组件的特殊逻辑）：
```jsx
// pages/Profile.jsx
import { useEffect } from ''react'';
import { useNavigate } from ''react-router-dom'';

export default function Profile() {
  const navigate = useNavigate();

  useEffect(() => {
    const isLogin = localStorage.getItem(''token'') === null;
    if (isLogin) {
      navigate(''/login'', { replace: true });
    }
  }, [navigate]);

  return <div>个人中心页面</div>;
}
```

# 3. 关键注意事项
1. **`replace` 属性**：重定向时使用 `replace: true`，避免在浏览器历史记录中留下重定向的痕迹（防止用户点击返回按钮回到无权限页面）。
2. **权限状态的实时性**：若项目中使用状态管理库（如 Redux、Pinia），需确保鉴权逻辑能响应状态变化（如用户登出后立即重定向）。
3. **服务端校验**：前端路由守卫仅用于提升用户体验，**真正的权限控制必须在服务端实现**（防止用户通过修改前端代码绕过守卫）。
4. **403/404 页面**：配置无权限页面（403）和页面不存在页面（404），提升用户体验：
   ```jsx
   <Route path="/403" element={<NoPermission />} />
   <Route path="*" element={<NotFound />} />
   ```
', '77b830a2-38dc-41a0-8e20-9f29ffc5a332', 'true', '2025-12-22 02:08:44.933755+00', '2025-12-23 02:51:59.324326+00'), ('bfb9f726-f542-4e40-9dfb-553beae09d54', '错误边界（Error Boundary）捕获组件异常', '# 1. 错误边界的核心概念
React 中，组件内的 JavaScript 错误（如渲染错误、事件处理错误、生命周期错误）若未捕获，会导致整个组件树崩溃，页面白屏。**错误边界（Error Boundary）** 是一种特殊的 React 组件，用于捕获其子组件树中抛出的错误，记录错误信息，并显示降级 UI（替代崩溃的组件），避免整个应用崩溃。

## 1.1 关键特性：
- 错误边界仅能捕获**子组件**的错误，无法捕获自身的错误；
- 错误边界能捕获的错误类型：
  - 渲染阶段的错误（如 JSX 语法错误、组件渲染时的逻辑错误）；
  - 生命周期方法中的错误（如 `componentDidMount`、`useEffect` 中的错误）；
  - 子组件构造函数中的错误；
- 错误边界**无法捕获**的错误类型：
  - 事件处理函数中的错误（如点击按钮触发的函数错误）；
  - 异步代码中的错误（如 `setTimeout`、`Promise` 回调中的错误）；
  - 服务端渲染中的错误；
  - 错误边界自身抛出的错误；

# 2. 如何创建错误边界组件
错误边界组件必须是**类组件**（React 暂不支持函数组件作为错误边界），需实现以下两个生命周期方法之一：
1. `static getDerivedStateFromError(error)`：静态方法，用于更新组件状态，显示降级 UI；
2. `componentDidCatch(error, info)`：实例方法，用于记录错误信息（如上报到日志系统）。

## 2.1 基础示例：
```javascript
import React, { Component } from ''react'';

class ErrorBoundary extends Component {
  constructor(props) {
    super(props);
    // 初始化状态：无错误
    this.state = { hasError: false, error: null, errorInfo: null };
  }

  // 捕获子组件错误，更新状态以显示降级 UI
  static getDerivedStateFromError(error) {
    return { hasError: true };
  }

  // 捕获错误详情，用于日志上报
  componentDidCatch(error, errorInfo) {
    // 记录错误信息（可上报到 Sentry、LogRocket 等平台）
    console.error(''错误边界捕获到错误：'', error, errorInfo);
    this.setState({
      error: error,
      errorInfo: errorInfo
    });
  }

  // 重置错误状态（可选）
  resetError = () => {
    this.setState({ hasError: false, error: null, errorInfo: null });
  };

  render() {
    // 若有错误，显示降级 UI
    if (this.state.hasError) {
      return (
        <div style={{ padding: ''20px'', textAlign: ''center'' }}>
          <h2>哎呀，组件出错了！</h2>
          <p>{this.state.error?.message}</p>
          <button onClick={this.resetError}>刷新组件</button>
          {/* 开发环境可显示错误栈（生产环境隐藏） */}
          {process.env.NODE_ENV === ''development'' && (
            <details style={{ marginTop: ''10px'', textAlign: ''left'' }}>
              <summary>错误详情</summary>
              {this.state.errorInfo?.componentStack}
            </details>
          )}
        </div>
      );
    }

    // 无错误时，渲染子组件
    return this.props.children;
  }
}

export default ErrorBoundary;
```

# 3. 错误边界的使用方式
## 3.1 包裹单个组件（局部错误处理）
```javascript
import ErrorBoundary from ''./ErrorBoundary'';
import BuggyComponent from ''./BuggyComponent''; // 可能抛出错误的组件

function App() {
  return (
    <div>
      <h1>我的应用</h1>
      {/* 用错误边界包裹易出错的组件 */}
      <ErrorBoundary>
        <BuggyComponent />
      </ErrorBoundary>
      {/* 其他组件不受影响 */}
      <div>其他正常组件</div>
    </div>
  );
}
```

## 3.2 包裹整个应用（全局错误处理）
```javascript
import ErrorBoundary from ''./ErrorBoundary'';
import MainContent from ''./MainContent'';

function App() {
  return (
    <ErrorBoundary>
      <MainContent />
    </ErrorBoundary>
  );
}
```

## 3.3 嵌套错误边界（精细化处理）
```javascript
// 全局错误边界（捕获根组件错误）
<ErrorBoundary fallback={<GlobalFallback />}>
  <div>
    {/* 局部错误边界（捕获列表组件错误） */}
    <ErrorBoundary fallback={<ListFallback />}>
      <ProductList />
    </ErrorBoundary>
    {/* 局部错误边界（捕获表单组件错误） */}
    <ErrorBoundary fallback={<FormFallback />}>
      <CheckoutForm />
    </ErrorBoundary>
  </div>
</ErrorBoundary>
```

# 4. 错误边界的最佳实践
1. **精准包裹**：仅包裹可能抛出错误的组件（如第三方组件、动态渲染的组件），避免全局包裹导致小错误被放大；
2. **分级降级 UI**：
   - 局部错误边界：显示组件级降级 UI（如“该模块加载失败，请重试”）；
   - 全局错误边界：显示应用级降级 UI（如“应用出错，请刷新页面”）；
3. **错误日志上报**：在 `componentDidCatch` 中集成错误监控工具（如 Sentry），实时上报错误信息，便于定位问题；
4. **开发与生产环境区分**：
   - 开发环境：显示详细错误栈，帮助调试；
   - 生产环境：隐藏敏感错误信息，仅显示友好提示；
5. **提供恢复机制**：添加“刷新组件”“重试”按钮，让用户无需刷新整个页面即可恢复；

# 5. 常见问题与解决方案
## 问题1：函数组件无法作为错误边界
解决方案：用类组件封装错误边界，或使用第三方库（如 `react-error-boundary`）提供的函数组件版错误边界。

## 问题2：事件处理错误无法被捕获
解决方案：在事件处理函数中手动 try/catch 捕获错误：
```javascript
function handleClick() {
  try {
    // 可能出错的代码
    riskyOperation();
  } catch (error) {
    console.error(''事件处理错误：'', error);
    // 显示错误提示或上报
  }
}
```

## 问题3：异步错误无法被捕获
解决方案：在异步代码中手动 try/catch，或使用 `unhandledrejection` 全局监听 Promise 错误：
```javascript
// 全局监听未捕获的 Promise 错误
window.addEventListener(''unhandledrejection'', (event) => {
  console.error(''未处理的 Promise 错误：'', event.reason);
  event.preventDefault(); // 阻止浏览器默认行为
});

// 异步函数内手动捕获
async function fetchData() {
  try {
    const res = await fetch(''/api/data'');
    const data = await res.json();
    return data;
  } catch (error) {
    console.error(''数据请求错误：'', error);
    throw error; // 若需让错误边界捕获，可重新抛出（需在渲染阶段）
  }
}
```', 'a02f0182-c167-4bad-9395-1aa29e0a493f', 'true', '2025-12-22 03:17:02.268055+00', '2025-12-23 09:52:44.136031+00'), ('c278feac-3eab-425c-b067-82c2a805aeed', '事件处理', '在 React 中，事件处理是构建交互式 UI 的核心能力。React 并没有直接使用原生 DOM 事件，而是实现了一套**合成事件系统**，它兼具跨浏览器兼容性和性能优势。同时，事件处理函数的 `this` 指向和参数传递也是开发中需要重点掌握的知识点。

# 1. React 合成事件系统
## 1.1 合成事件的概念
**合成事件（SyntheticEvent）** 是 React 模拟原生 DOM 事件的跨浏览器包装对象，它将不同浏览器的原生事件行为进行了标准化，提供了与原生事件一致的 API（如 `stopPropagation`、`preventDefault`）。

简单来说，合成事件不是原生 DOM 事件，但它可以模拟原生事件的所有功能，并且在所有浏览器中表现一致。

## 1.2 合成事件的特点
1. **跨浏览器兼容性**
    不同浏览器的原生事件存在差异（如 IE 的 `attachEvent` vs 标准浏览器的 `addEventListener`），React 合成事件封装了这些差异，开发者无需关心浏览器兼容问题。
2. **事件委托机制**
    React 并不会给每个元素绑定事件处理器，而是将所有事件委托到**根节点**（`document`）上。当事件触发时，React 会根据事件冒泡路径找到对应的组件，再执行事件处理函数。这种机制减少了大量的事件绑定操作，提升了性能。
3. **与原生事件的关系**
    合成事件内部持有原生事件的引用，可以通过 `e.nativeEvent` 获取原生事件对象。
    ```jsx
    function handleClick(e) {
      // e 是合成事件对象
      console.log(e.nativeEvent); // 获取原生 DOM 事件对象
    }
    ```
4. **合成事件的生命周期**
    合成事件对象会在事件处理函数执行完毕后被**回收复用**，因此不能在异步操作中访问合成事件对象的属性。如果需要在异步中使用，需要调用 `e.persist()` 方法保留事件对象。
    ```jsx
    function handleClick(e) {
      e.persist(); // 保留合成事件对象
      setTimeout(() => {
        console.log(e.target); // 异步中可以正常访问
      }, 1000);
    }
    ```

## 1.3 合成事件与原生事件的区别
| 特性 | React 合成事件 | 原生 DOM 事件 |
|------|----------------|--------------|
| 绑定方式 | 通过 JSX 属性（如 `onClick`） | 通过 `addEventListener` |
| 事件名 | 小驼峰命名（如 `onMouseOver`） | 全小写（如 `mouseover`） |
| 事件委托 | 委托到 document | 无默认委托 |
| 跨浏览器兼容 | 自动兼容 | 需手动处理兼容 |
| 事件对象 | SyntheticEvent | 原生 Event 对象 |

# 2. 事件处理函数的 this 指向问题
在 React 类组件中，事件处理函数的 `this` 指向是一个常见的坑。默认情况下，类组件的方法不会绑定 `this`，如果直接作为事件处理函数使用，`this` 会指向 `undefined`（严格模式下）。

## 2.1 问题复现
```jsx
import React, { Component } from ''react'';

class Button extends Component {
  constructor(props) {
    super(props);
    this.state = { count: 0 };
  }

  handleClick() {
    // 这里的 this 是 undefined
    this.setState({ count: this.state.count + 1 });
  }

  render() {
    return <button onClick={this.handleClick}>点击计数</button>;
  }
}
```
当点击按钮时，会报错 `Cannot read property ''setState'' of undefined`，原因是 `handleClick` 函数的 `this` 没有绑定到组件实例。

## 2.2 解决方法
### 方法1：构造函数中绑定 this（推荐）
在组件的 `constructor` 中，通过 `bind` 方法将事件处理函数的 `this` 绑定到组件实例。
```jsx
constructor(props) {
  super(props);
  this.state = { count: 0 };
  // 绑定 this
  this.handleClick = this.handleClick.bind(this);
}
```
这种方法的优势是只需要绑定一次，性能较高。

### 方法2：使用箭头函数定义事件处理函数
箭头函数的 `this` 会继承外层作用域的 `this`（即组件实例），因此不需要手动绑定。
```jsx
// 箭头函数形式，this 指向组件实例
handleClick = () => {
  this.setState({ count: this.state.count + 1 });
};
```
这种方法写法简洁，是目前类组件中常用的方式。

### 方法3：调用时使用箭头函数
在 JSX 的事件绑定中，直接使用箭头函数包裹事件处理函数。
```jsx
render() {
  return (
    <button onClick={() => this.handleClick()}>点击计数</button>
  );
}
```
这种方法的缺点是：每次组件渲染时都会创建一个新的箭头函数，可能会影响性能（尤其是在列表渲染中），并且会导致子组件的 `shouldComponentUpdate` 失效。

## 2.3 函数组件中的 this 问题
函数组件中没有 `this` 指向，因此不需要考虑 `this` 绑定问题，直接定义事件处理函数即可。
```jsx
import { useState } from ''react'';

function Button() {
  const [count, setCount] = useState(0);

  const handleClick = () => {
    setCount(count + 1);
  };

  return <button onClick={handleClick}>计数：{count}</button>;
}
```

# 3. 事件处理函数的参数传递
在实际开发中，我们经常需要给事件处理函数传递额外的参数（如列表项的 ID、索引等）。React 提供了多种事件传参的方式。

## 方式1：箭头函数传参
在事件绑定处使用箭头函数，直接传递参数给事件处理函数。
```jsx
import { useState } from ''react'';

function ItemList() {
  const [items] = useState([''苹果'', ''香蕉'', ''橙子'']);

  const handleItemClick = (item, index) => {
    console.log(`点击了第 ${index} 项：${item}`);
  };

  return (
    <ul>
      {items.map((item, index) => (
        <li key={index} onClick={() => handleItemClick(item, index)}>
          {item}
        </li>
      ))}
    </ul>
  );
}
```
这种方式直观易懂，是最常用的传参方法。

## 方式2：bind 方法传参
利用 `bind` 方法的特性，在绑定 `this` 的同时传递额外参数。
```jsx
// 类组件示例
class ItemList extends Component {
  state = { items: [''苹果'', ''香蕉'', ''橙子''] };

  handleItemClick(item, index) {
    console.log(`点击了第 ${index} 项：${item}`);
  }

  render() {
    return (
      <ul>
        {this.state.items.map((item, index) => (
          <li key={index} onClick={this.handleItemClick.bind(this, item, index)}>
            {item}
          </li>
        ))}
      </ul>
    );
  }
}
```
`bind` 方法的第一个参数是 `this` 指向，后续参数会作为事件处理函数的参数传入。

## 方式3：通过自定义属性传参
可以通过元素的自定义属性（如 `data-*`）存储参数，在事件处理函数中通过 `e.target.dataset` 获取。
```jsx
function ItemList() {
  const [items] = useState([''苹果'', ''香蕉'', ''橙子'']);

  const handleItemClick = (e) => {
    const item = e.target.dataset.item;
    const index = e.target.dataset.index;
    console.log(`点击了第 ${index} 项：${item}`);
  };

  return (
    <ul>
      {items.map((item, index) => (
        <li 
          key={index} 
          data-item={item} 
          data-index={index} 
          onClick={handleItemClick}
        >
          {item}
        </li>
      ))}
    </ul>
  );
}
```
这种方式适合参数较少的场景，避免创建额外的函数。

# 4. 注意事项
1. 合成事件的 `stopPropagation` 方法只能阻止合成事件的冒泡，无法阻止原生事件的冒泡；如果需要阻止原生事件冒泡，需要使用 `e.nativeEvent.stopImmediatePropagation()`。
2. 避免在事件处理函数中直接修改 `state`，应该使用 `setState`（类组件）或 `setXxx`（函数组件）进行状态更新。
3. 对于高频触发的事件（如 `onScroll`、`onMouseMove`），可以使用**防抖（debounce）**或**节流（throttle）**优化性能。', '763e50ae-d5ad-4770-b985-cb78491214e1', 'true', '2025-12-19 08:59:29.142825+00', '2025-12-19 08:59:29.142825+00'), ('c4af30a0-f1d1-46cd-89e4-f30a84d4f9fc', 'props校验', '# 4. props 校验（PropTypes/TypeScript 接口）
在多人协作或大型项目中，组件的 `props` 传递可能出现类型错误（如预期传递数字却传了字符串）、必填参数缺失等问题，导致组件运行异常且难以调试。React 支持通过 **PropTypes** 或 **TypeScript 接口** 对 `props` 进行类型校验，提前发现错误，提升代码健壮性。

# 1. PropTypes 校验（JavaScript 项目常用）
PropTypes 是 React 官方提供的 props 校验库（React 15.5 后需单独安装 `prop-types` 包），支持对 props 的类型、必填项、默认值等进行校验，开发环境下若校验失败，会在控制台输出警告。

## 1.1 安装依赖
```bash
npm install prop-types --save
# 或 yarn add prop-types
```

## 1.2 基本使用
### （1）函数组件校验
```jsx
import PropTypes from ''prop-types'';

function UserCard(props) {
  return (
    <div>
      <p>姓名：{props.name}</p>
      <p>年龄：{props.age}</p>
      <p>性别：{props.gender}</p>
      <p>技能：{props.skills.join(''、'')}</p>
    </div>
  );
}

// 定义 props 校验规则
UserCard.propTypes = {
  // 姓名：字符串类型，必填（isRequired）
  name: PropTypes.string.isRequired,
  // 年龄：数字类型，可选
  age: PropTypes.number,
  // 性别：字符串类型，可选，且只能是指定值之一（oneOf）
  gender: PropTypes.oneOf([''male'', ''female'', ''other'']),
  // 技能：数组类型，数组元素为字符串（arrayOf）
  skills: PropTypes.arrayOf(PropTypes.string),
  // 个人信息：对象类型，指定对象的属性类型（shape）
  info: PropTypes.shape({
    address: PropTypes.string,
    phone: PropTypes.number
  }),
  // 回调函数：函数类型（func）
  onHandle: PropTypes.func,
  // 任意类型（不推荐，失去校验意义）
  anyProp: PropTypes.any
};

// 可选：设置 props 默认值（与校验规则对应）
UserCard.defaultProps = {
  age: 18,
  gender: ''other'',
  skills: [],
  info: {},
  onHandle: () => {}
};
```

### （2）类组件校验
```jsx
import React from ''react'';
import PropTypes from ''prop-types'';

class UserCard extends React.Component {
  render() {
    const { name, age } = this.props;
    return (
      <div>
        <p>姓名：{name}</p>
        <p>年龄：{age}</p>
      </div>
    );
  }
}

// 类组件的 props 校验规则定义方式与函数组件一致
UserCard.propTypes = {
  name: PropTypes.string.isRequired,
  age: PropTypes.number
};

UserCard.defaultProps = {
  age: 18
};
```

## 1.3 PropTypes 支持的校验类型
| 校验类型 | 说明 | 示例 |
|----------|------|------|
| `PropTypes.string` | 字符串类型 | `name: PropTypes.string` |
| `PropTypes.number` | 数字类型 | `age: PropTypes.number` |
| `PropTypes.bool` | 布尔类型 | `isActive: PropTypes.bool` |
| `PropTypes.func` | 函数类型 | `onClick: PropTypes.func` |
| `PropTypes.array` | 数组类型 | `list: PropTypes.array` |
| `PropTypes.object` | 对象类型 | `info: PropTypes.object` |
| `PropTypes.symbol` | Symbol 类型 | `key: PropTypes.symbol` |
| `PropTypes.node` | 可渲染节点（字符串、数字、JSX 等） | `children: PropTypes.node` |
| `PropTypes.element` | React 元素（JSX 组件） | `child: PropTypes.element` |
| `PropTypes.oneOf([...])` | 枚举类型，值必须是数组中的某一个 | `gender: PropTypes.oneOf([''male'', ''female''])` |
| `PropTypes.oneOfType([...])` | 多种类型之一 | `id: PropTypes.oneOfType([PropTypes.string, PropTypes.number])` |
| `PropTypes.arrayOf(类型)` | 数组，且元素为指定类型 | `skills: PropTypes.arrayOf(PropTypes.string)` |
| `PropTypes.objectOf(类型)` | 对象，且属性值为指定类型 | `scores: PropTypes.objectOf(PropTypes.number)` |
| `PropTypes.shape({...})` | 对象，且指定属性的类型 | `info: PropTypes.shape({ address: PropTypes.string })` |
| `PropTypes.instanceOf(类)` | 指定类的实例 | `date: PropTypes.instanceOf(Date)` |
| `PropTypes.isRequired` | 必填项（可搭配任意类型） | `name: PropTypes.string.isRequired` |
| `PropTypes.any` | 任意类型（不推荐） | `anyProp: PropTypes.any` |

## 1.4 自定义校验规则
若 PropTypes 内置的校验类型无法满足需求，可自定义校验函数，接收 `props`、`propName`（当前校验的属性名）、`componentName`（组件名）三个参数，校验失败时返回 Error 对象：
```jsx
UserCard.propTypes = {
  // 自定义校验：年龄必须大于 0
  age: function(props, propName, componentName) {
    const age = props[propName];
    if (age <= 0 || typeof age !== ''number'') {
      // 校验失败，返回 Error 警告
      return new Error(`组件 ${componentName} 的 ${propName} 属性必须是大于 0 的数字`);
    }
  },
  // 自定义数组校验：技能数组长度不能超过 5 个
  skills: PropTypes.arrayOf(PropTypes.string).isRequired,
  skills: function(props, propName, componentName) {
    const skills = props[propName];
    if (skills.length > 5) {
      return new Error(`组件 ${componentName} 的 ${propName} 数组长度不能超过 5`);
    }
  }
};
```

## 1.5 注意事项
- **仅开发环境生效**：PropTypes 校验仅在开发环境（`process.env.NODE_ENV === ''development''`）输出警告，生产环境会自动移除，不影响性能。
- **默认值与校验的配合**：`defaultProps` 定义的默认值会覆盖 `isRequired` 校验（即若设置了默认值，即使未传递该 props，也不会触发必填警告）。
- **不阻止组件渲染**：校验失败仅输出警告，不会阻止组件渲染，需开发者主动修复问题。

# 2. TypeScript 接口校验（TS 项目推荐）
TypeScript（TS）是 JavaScript 的超集，支持静态类型检查，通过**接口（Interface）** 或**类型别名（Type）** 定义 props 的类型，在编译阶段就能发现类型错误，比 PropTypes 更严格、更强大，是 TS 项目的首选方案。

## 2.1 基本使用（函数组件 + Interface）
通过 `interface` 定义 props 的类型结构，组件通过泛型 `React.FC<PropsType>` 关联类型，TS 会自动校验 props 的类型和必填项：
```tsx
import React from ''react'';

// 定义 props 接口（Interface）
interface UserCardProps {
  name: string; // 字符串类型，必填（未加 ? 表示必填）
  age?: number; // 数字类型，可选（加 ? 表示可选）
  gender?: ''male'' | ''female'' | ''other''; // 枚举类型，可选
  skills: string[]; // 字符串数组，必填
  info?: {
    address: string;
    phone?: number;
  }; // 嵌套对象类型，可选
  onHandle?: () => void; // 函数类型，可选（无参数，无返回值）
}

// 组件通过泛型 React.FC<UserCardProps> 关联 props 类型
const UserCard: React.FC<UserCardProps> = (props) => {
  // 解构 props，TS 会自动提示属性并校验类型
  const { name, age = 18, gender = ''other'', skills, info } = props;

  return (
    <div>
      <p>姓名：{name}</p>
      <p>年龄：{age}</p>
      <p>性别：{gender}</p>
      <p>技能：{skills.join(''、'')}</p>
      <p>地址：{info?.address}</p> {/* 可选链操作符，避免 info 为 undefined 报错 */}
    </div>
  );
};

// 可选：设置默认值（与 Interface 可选属性对应）
UserCard.defaultProps = {
  age: 18,
  gender: ''other'',
  info: {}
};

export default UserCard;
```

## 2.2 类组件 + Interface
类组件通过 `React.Component<PropsType, StateType>` 泛型关联 props 类型：
```tsx
import React from ''react'';

interface UserCardProps {
  name: string;
  age?: number;
}

interface UserCardState {
  isExpanded: boolean;
}

// 类组件泛型：第一个参数是 Props 类型，第二个是 State 类型
class UserCard extends React.Component<UserCardProps, UserCardState> {
  // 初始化状态
  state: UserCardState = {
    isExpanded: false
  };

  render() {
    const { name, age = 18 } = this.props; // TS 自动校验 this.props 类型
    return (
      <div>
        <p>姓名：{name}</p>
        <p>年龄：{age}</p>
      </div>
    );
  }
}

export default UserCard;
```

## 2.3 常用 TS 类型与 PropTypes 对应关系
| PropTypes 类型 | TypeScript 类型 | 示例 |
|----------------|----------------|------|
| `PropTypes.string` | `string` | `name: string` |
| `PropTypes.number` | `number` | `age: number` |
| `PropTypes.bool` | `boolean` | `isActive: boolean` |
| `PropTypes.func` | `() => void` / `(param: T) => R` | `onClick: () => void` |
| `PropTypes.array` | `T[]` / `Array<T>` | `skills: string[]` |
| `PropTypes.object` | `{ [key: string]: T }` / 接口 | `info: { address: string }` |
| `PropTypes.oneOf([...])` | 联合类型 `A | B | C` | `gender: ''male'' | ''female''` |
| `PropTypes.oneOfType([...])` | 联合类型 `A | B` | `id: string | number` |
| `PropTypes.arrayOf(类型)` | `T[]` | `scores: number[]` |
| `PropTypes.shape({...})` | 接口 `interface` | `info: { phone: number }` |
| `PropTypes.isRequired` | 未加 `?` 的属性 | `name: string`（必填） |
| `PropTypes.node` | `React.ReactNode` | `children: React.ReactNode` |
| `PropTypes.element` | `React.ReactElement` | `child: React.ReactElement` |

## 2.4 高级用法：泛型 Props
若组件的 props 类型需要动态适配（如列表组件支持不同类型的数据），可使用 TS 泛型定义 props：
```tsx
import React from ''react'';

// 泛型接口：T 是动态类型，使用时指定
interface ListProps<T> {
  data: T[]; // 数组元素类型为 T
  renderItem: (item: T) => React.ReactNode; // 渲染函数，参数类型为 T
}

// 泛型组件：<T> 表示接收泛型参数
function List<T>({ data, renderItem }: ListProps<T>) {
  return (
    <div>
      {data.map((item, index) => renderItem(item))}
    </div>
  );
}

// 使用组件时，指定泛型类型为 User 接口
interface User {
  id: number;
  name: string;
}

function App() {
  const userList: User[] = [
    { id: 1, name: ''张三'' },
    { id: 2, name: ''李四'' }
  ];

  return (
    <List<User>
      data={userList}
      renderItem={(item) => <p>姓名：{item.name}</p>} // TS 自动提示 item 的属性
    </List>
  );
}
```

# 3. PropTypes 与 TypeScript 对比
| 维度 | PropTypes | TypeScript 接口 |
|------|-----------|----------------|
| **校验时机** | 运行时（开发环境控制台警告） | 编译时（编写代码/编译阶段报错） |
| **严格性** | 宽松，仅警告不阻止运行 | 严格，类型不匹配无法编译通过 |
| **功能丰富度** | 基础类型校验，支持自定义函数 | 支持泛型、联合类型、交叉类型等复杂场景 |
| **代码侵入性** | 需额外定义 `propTypes` 属性 | 与组件类型定义融合，无额外冗余 |
| **学习成本** | 低，API 简单直观 | 高，需掌握 TS 基础语法 |
| **适用项目** | JavaScript 项目、小型项目 | TypeScript 项目、中大型项目、多人协作项目 |

# 4. 核心总结
1. **校验目的**：确保 props 类型正确、必填项不缺失，提前发现错误，提升代码健壮性。
2. **方案选型**：
   - JavaScript 项目：使用 PropTypes，学习成本低，快速实现基础校验。
   - TypeScript 项目：使用接口/类型别名，编译时校验，支持复杂场景，推荐优先使用。
3. **关键注意**：
   - PropTypes 仅开发环境生效，不影响生产环境性能。
   - TS 接口需与组件泛型关联，才能实现自动类型提示和校验。
4. **最佳实践**：无论使用哪种方案，都应明确 props 的类型和必填项，配合默认值使用，减少潜在 bug。...', '803ada09-ee46-463c-b7f3-403560bfc20b', 'true', '2025-12-19 11:07:58.047397+00', '2025-12-19 11:07:58.047397+00'), ('cc52365e-6b7a-4d68-8d0e-381c9fc9b173', 'memo/useMemo/useCallback 实战', '`memo`、`useMemo`、`useCallback` 是 React 提供的三大缓存工具，核心目标是**通过缓存避免不必要的重渲染和重复计算**，但滥用会增加内存开销，需精准使用。

# 1. React.memo：组件缓存
## 1.1 作用
`React.memo` 是高阶组件（HOC），用于缓存函数组件，让组件仅在 props 发生**浅层对比变化**时重渲染，避免父组件重渲染导致子组件无意义重渲染。

## 1.2 基本用法
```javascript
import { memo } from ''react'';

// 子组件：仅在 name/age 变化时重渲染
const UserCard = memo(({ name, age }) => {
  console.log(''UserCard 渲染''); // 测试是否重渲染
  return (
    <div>
      <h3>{name}</h3>
      <p>年龄：{age}</p>
    </div>
  );
});

// 父组件
function Parent() {
  const [count, setCount] = useState(0);
  const user = { name: ''张三'', age: 20 }; // 每次渲染生成新对象

  return (
    <div>
      <button onClick={() => setCount(count + 1)}>计数：{count}</button>
      {/* 问题：父组件重渲染时，user 是新对象 → UserCard 重渲染 */}
      <UserCard name={user.name} age={user.age} />
      {/* 优化：直接传递基础类型 props，避免新对象引用 */}
      {/* <UserCard name="张三" age={20} /> */}
    </div>
  );
}
```

## 1.3 关键细节
1. **浅层对比**：`React.memo` 默认对 props 进行浅层对比（基础类型比较值，引用类型比较引用），若 props 包含嵌套对象/数组，浅层对比无法识别内部变化，需自定义对比函数。
2. **自定义对比函数**：
   ```javascript
   const UserCard = memo(({ user }) => {
     return <div>{user.name}</div>;
   }, (prevProps, nextProps) => {
     // 自定义对比逻辑：仅当 user.name 变化时重渲染
     return prevProps.user.name === nextProps.user.name;
   });
   ```
3. **适用场景**：
   - 子组件渲染成本高（如包含复杂 DOM 结构、大量计算）；
   - 父组件频繁重渲染，但子组件 props 很少变化；
   - 避免：纯展示型轻量组件（缓存开销 > 重渲染开销）。

# 2. useCallback：函数缓存
## 2.1 作用
`useCallback` 用于缓存函数引用，避免每次组件渲染生成新的函数实例，从而防止因函数 props 变化触发子组件重渲染（配合 `React.memo` 使用）。

## 2.2 基本用法
```javascript
import { useState, memo, useCallback } from ''react'';

const Button = memo(({ onClick, children }) => {
  console.log(''Button 渲染'');
  return <button onClick={onClick}>{children}</button>;
});

function Parent() {
  const [count, setCount] = useState(0);
  const [text, setText] = useState('''');

  // 问题：每次渲染生成新函数 → Button 重渲染
  // const handleClick = () => {
  //   console.log(''点击按钮'');
  // };

  // 优化：用 useCallback 缓存函数，仅依赖项变化时生成新函数
  const handleClick = useCallback(() => {
    console.log(''点击按钮'');
  }, []); // 空依赖：组件生命周期内函数引用不变

  return (
    <div>
      <input value={text} onChange={(e) => setText(e.target.value)} />
      <Button onClick={handleClick}>点击我</Button>
    </div>
  );
}
```

## 2.3 关键细节
1. **依赖项数组**：`useCallback` 第二个参数是依赖项数组，当依赖项变化时，会生成新的函数实例；若依赖项为空数组，函数在组件挂载时生成一次，后续不变。
2. **配合 React.memo 使用**：`useCallback` 仅在子组件使用 `React.memo` 时才有意义，否则即使缓存函数，子组件仍会因父组件重渲染而重渲染。
3. **适用场景**：
   - 函数作为 props 传递给子组件（且子组件用 `React.memo` 缓存）；
   - 函数作为 `useEffect` 的依赖项（避免每次渲染触发 effect）；
   - 避免：函数仅在组件内部使用（无需缓存）。

# 3. useMemo：计算结果缓存
## 3.1 作用
`useMemo` 用于缓存复杂计算的结果，避免每次组件渲染重复执行昂贵的计算操作，同时可缓存引用类型（对象/数组），防止因新引用触发子组件重渲染。

## 3.2 基本用法（缓存计算结果）
```javascript
import { useState, useMemo } from ''react'';

function DataList() {
  const [data, setData] = useState([1, 2, 3, 4, 5]);
  const [filter, setFilter] = useState(3);

  // 问题：每次渲染执行过滤+排序（昂贵计算）
  // const filteredData = data.filter(item => item > filter).sort((a, b) => b - a);

  // 优化：用 useMemo 缓存计算结果，仅 filter/data 变化时重新计算
  const filteredData = useMemo(() => {
    console.log(''执行过滤排序'');
    return data.filter(item => item > filter).sort((a, b) => b - a);
  }, [data, filter]);

  return (
    <div>
      <input
        type="number"
        value={filter}
        onChange={(e) => setFilter(Number(e.target.value))}
      />
      <ul>
        {filteredData.map(item => (
          <li key={item}>{item}</li>
        ))}
      </ul>
    </div>
  );
}
```

## 3.3 进阶用法（缓存引用类型）
```javascript
import { useState, memo, useMemo } from ''react'';

const UserInfo = memo(({ user }) => {
  console.log(''UserInfo 渲染'');
  return <div>{user.name} - {user.age}</div>;
});

function Parent() {
  const [count, setCount] = useState(0);

  // 问题：每次渲染生成新对象 → UserInfo 重渲染
  // const user = { name: ''张三'', age: 20 };

  // 优化：用 useMemo 缓存对象，引用不变
  const user = useMemo(() => ({ name: ''张三'', age: 20 }), []);

  return (
    <div>
      <button onClick={() => setCount(count + 1)}>计数：{count}</button>
      <UserInfo user={user} />
    </div>
  );
}
```

## 3.4 关键细节
1. **依赖项数组**：`useMemo` 第二个参数是依赖项数组，仅当依赖项变化时重新计算；若依赖项为空数组，计算结果在组件挂载时生成一次。
2. **与 useCallback 的区别**：
   - `useCallback` 缓存函数引用；
   - `useMemo` 缓存函数执行结果（可是任意类型）。
3. **适用场景**：
   - 执行昂贵计算（如大数据集过滤、排序、格式化）；
   - 缓存引用类型（对象/数组）作为 props 传递给子组件；
   - 避免：简单计算（如 `a + b`）、基础类型值（缓存开销 > 计算开销）。

# 4. 三大缓存工具的使用原则
1. **不滥用缓存**：缓存会占用内存，且对比依赖项也有微小开销，仅在确有性能问题时使用；
2. **精准设置依赖项**：遗漏依赖项会导致缓存结果过期（Bug），多余依赖项会导致缓存失效（失去优化意义）；
3. **配合使用**：
   - 子组件用 `React.memo` 缓存；
   - 传递给子组件的函数用 `useCallback` 缓存；
   - 传递给子组件的引用类型用 `useMemo` 缓存；
4. **优先优化代码结构**：拆分组件、减少 props 传递，比缓存更根本的优化方式。', 'e9432055-c489-48b5-964a-81d34278fc72', 'true', '2025-12-22 03:15:40.945601+00', '2025-12-23 09:43:28.148447+00'), ('cea79b33-f4a1-4b54-8741-2349f1c8d323', '列表渲染优化', '当渲染**长列表**（如 1000+ 条数据）时，直接渲染所有列表项会导致：
- 大量 DOM 节点创建，占用内存过高；
- 虚拟 DOM Diff 算法耗时增加，渲染卡顿；
- 页面滚动时帧率下降，交互不流畅。

列表渲染优化的核心思路是：**只渲染可视区域内的列表项，动态销毁/创建非可视区域的列表项**，即“虚拟列表”（Virtual List）。

# 1. 虚拟列表的核心原理
1. **计算可视区域**：根据容器高度、滚动位置，计算当前能看到的列表项范围；
2. **渲染可视项**：仅渲染可视区域内的列表项，非可视区域用空白占位符填充；
3. **滚动监听**：监听滚动事件，动态更新可视区域范围，替换列表项内容；
4. **复用 DOM 节点**：（可选）复用已创建的 DOM 节点，减少创建/销毁开销。

# 2. React Window：轻量级虚拟列表库
`react-window` 是 React 生态中最流行的虚拟列表库，体积小（~5KB gzip）、性能高，支持固定高度/可变高度列表、网格布局等。

## 2.1 安装
```bash
npm install react-window

yarn add react-window
```

## 2.2 基础用法（固定高度列表）
```javascript
import { FixedSizeList as List } from ''react-window'';

// 模拟 10000 条数据
const data = Array.from({ length: 10000 }, (_, index) => `列表项 ${index + 1}`);

// 列表项组件
const Row = ({ index, style }) => {
  // style 必须传递给根元素（用于定位）
  return (
    <div style={style}>
      {data[index]}
    </div>
  );
};

function LongList() {
  return (
    // height：容器高度；width：容器宽度；itemCount：总项数；itemSize：每项高度
    <List
      height={500}
      width="100%"
      itemCount={data.length}
      itemSize={50} // 每项固定高度 50px
    >
      {Row}
    </List>
  );
}
```

## 2.3 进阶用法（可变高度列表）
若列表项高度不固定，使用 `VariableSizeList`：
```javascript
import { VariableSizeList as List } from ''react-window'';

// 模拟可变高度数据（高度随机 30-100px）
const data = Array.from({ length: 10000 }, (_, index) => ({
  text: `列表项 ${index + 1}`,
  height: 30 + Math.floor(Math.random() * 70)
}));

// 获取每项高度
const getItemSize = (index) => data[index].height;

const Row = ({ index, style }) => {
  return (
    <div style={style}>
      {data[index].text}（高度：{data[index].height}px）
    </div>
  );
};

function VariableHeightList() {
  return (
    <List
      height={500}
      width="100%"
      itemCount={data.length}
      itemSize={getItemSize} // 动态获取每项高度
    >
      {Row}
    </List>
  );
}
```

## 2.4 关键属性
| 属性 | 作用 |
|------|------|
| `height` | 列表容器高度（必填）|
| `width` | 列表容器宽度（必填）|
| `itemCount` | 列表总项数（必填）|
| `itemSize` | 每项高度（固定高度列表）或返回高度的函数（可变高度列表）|
| `overscanCount` | 预渲染可视区域外的项数（默认 1，增加可减少滚动时的空白闪烁）|
| `onScroll` | 滚动事件回调（可获取滚动位置、可视区域范围）|

# 3. React Virtualized：功能更全的虚拟列表库
`react-virtualized` 是 `react-window` 的前身，功能更丰富（支持表格、网格、瀑布流），但体积更大（~30KB gzip），适合复杂场景。

## 3.1 安装
```bash
npm install react-virtualized

yarn add react-virtualized
```

## 3.2 基础用法（List 组件）
```javascript
import { List, AutoSizer } from ''react-virtualized'';
import ''react-virtualized/styles.css''; // 引入样式

const data = Array.from({ length: 10000 }, (_, index) => `列表项 ${index + 1}`);

const rowRenderer = ({ index, key, style }) => {
  return (
    <div key={key} style={style}>
      {data[index]}
    </div>
  );
};

function LongList() {
  return (
    // AutoSizer：自动适配父容器尺寸
    <AutoSizer>
      {({ height, width }) => (
        <List
          height={height}
          width={width}
          rowCount={data.length}
          rowHeight={50}
          rowRenderer={rowRenderer}
        />
      )}
    </AutoSizer>
  );
}
```

## 3.3 瀑布流布局（Masonry 组件）
```javascript
import { Masonry, AutoSizer } from ''react-virtualized'';
import ''react-virtualized/styles.css'';

// 模拟瀑布流数据（宽度固定，高度随机）
const data = Array.from({ length: 100 }, (_, index) => ({
  id: index,
  height: 100 + Math.floor(Math.random() * 200)
}));

const cellRenderer = ({ index, key, style }) => {
  const item = data[index];
  return (
    <div key={key} style={{ ...style, backgroundColor: ''#f0f0f0'', margin: ''5px'' }}>
      瀑布流项 {item.id}（高度：{item.height}px）
    </div>
  );
};

function MasonryLayout() {
  return (
    <div style={{ height: 800 }}>
      <AutoSizer>
        {({ width }) => (
          <Masonry
            width={width}
            height={800}
            columnCount={3} // 列数
            columnWidth={width / 3 - 10} // 列宽度（减去间距）
            cellCount={data.length}
            cellMeasurerCache={{
              defaultHeight: 150,
              defaultWidth: width / 3 - 10
            }}
            cellRenderer={cellRenderer}
          />
        )}
      </AutoSizer>
    </div>
  );
}
```

# 4. 列表渲染优化的其他策略
1. **分页加载**：若无需滚动加载，可采用分页（每页渲染 20-50 条），减少单次渲染数量；
2. **数据预加载**：滚动到列表底部时，提前加载下一页数据，避免用户等待；
3. **列表项缓存**：用 `React.memo` 缓存列表项组件，避免因列表重渲染导致项组件无意义重渲染；
4. **避免复杂列表项**：简化列表项 DOM 结构，减少项组件内的计算操作；
5. **图片懒加载**：列表项中的图片使用 `loading="lazy"` 或第三方懒加载库（如 `react-lazyload`），减少首屏加载时间。

# 5. react-window vs react-virtualized
| 特性 | react-window | react-virtualized |
|------|--------------|-------------------|
| 体积 | 极小（~5KB） | 较大（~30KB）|
| 功能 | 基础（列表、网格） | 丰富（列表、表格、瀑布流、日历） |
| 性能 | 高（专注核心场景） | 中（功能多导致开销增加） |
| 易用性 | 简单（API 简洁） | 复杂（配置项多） |
| 适用场景 | 简单长列表、移动端 | 复杂布局（表格、瀑布流）、PC 端 |', 'e9432055-c489-48b5-964a-81d34278fc72', 'true', '2025-12-22 03:15:52.550016+00', '2025-12-23 09:47:25.549385+00'), ('d707298e-f817-4b74-9ce2-db6019393a7a', '懒加载路由', '默认情况下，React 项目打包后会将所有组件代码合并到一个或几个 bundle 文件中——当项目体积较大时，首屏加载时间会变长，影响用户体验。**路由懒加载**（也叫“代码分割”）的核心思想是：将不同路由对应的组件拆分成独立的代码块，只有当用户访问该路由时，才加载对应的代码块，从而减小首屏加载体积，提升加载速度。

React 中实现路由懒加载的核心工具是：
- `React.lazy`：动态导入组件（返回一个 Promise），实现组件的懒加载；
- `Suspense`：配合 `React.lazy` 使用，在懒加载组件加载完成前显示加载占位符（如加载动画、文字）。

# 1. 基本使用步骤
## 1.1 导入核心 API
```jsx
import { BrowserRouter, Routes, Route } from ''react-router-dom'';
import { lazy, Suspense } from ''react'';
```

## 1.2 用 `React.lazy` 动态导入路由组件
替换传统的 `import` 导入方式，改用 `lazy` 包裹动态导入函数：
```jsx
// 传统导入（打包时合并到主 bundle）
// import Home from ''./pages/Home'';
// import About from ''./pages/About'';
// import Dashboard from ''./pages/Dashboard'';

// 懒加载导入（拆分为独立代码块）
const Home = lazy(() => import(''./pages/Home''));
const About = lazy(() => import(''./pages/About''));
const Dashboard = lazy(() => import(''./pages/Dashboard''));
```

## 1.3 用 `Suspense` 包裹路由组件
`Suspense` 必须包裹懒加载组件，用于指定加载过程中的占位内容（`fallback` 属性）：
```jsx
function App() {
  return (
    <BrowserRouter>
      {/* Suspense 包裹所有懒加载路由组件，fallback 为加载占位符 */}
      <Suspense fallback={<div>Loading...</div>}>
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/about" element={<About />} />
          <Route path="/dashboard" element={<Dashboard />} />
        </Routes>
      </Suspense>
    </BrowserRouter>
  );
}
```

# 2. 进阶优化
## 2.1 分路由配置 `Suspense`
若希望不同路由使用不同的加载占位符，可给每个路由单独配置 `Suspense`：
```jsx
function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route 
          path="/about" 
          element={
            <Suspense fallback={<div>正在加载关于页面...</div>}>
              <About />
            </Suspense>
          } 
        />
        <Route 
          path="/dashboard" 
          element={
            <Suspense fallback={<div>后台数据加载中...</div>}>
              <Dashboard />
            </Suspense>
          } 
        />
      </Routes>
    </BrowserRouter>
  );
}
```

## 2.2 加载错误处理
懒加载组件可能因网络问题加载失败，需配合错误边界（Error Boundary）捕获错误：
```jsx
// 定义错误边界组件
class ErrorBoundary extends React.Component {
  state = { hasError: false };

  static getDerivedStateFromError() {
    return { hasError: true };
  }

  componentDidCatch(error) {
    console.error(''组件加载失败：'', error);
  }

  render() {
    if (this.state.hasError) {
      return <div>页面加载失败，请刷新重试～</div>;
    }
    return this.props.children;
  }
}

// 使用错误边界包裹懒加载组件
<Route 
  path="/dashboard" 
  element={
    <ErrorBoundary>
      <Suspense fallback={<div>加载中...</div>}>
        <Dashboard />
      </Suspense>
    </ErrorBoundary>
  } 
/>
```

## 2.3 预加载组件（可选）
若预判用户可能会访问某个路由（如鼠标悬停在导航链接上时），可手动触发组件预加载，提升后续访问速度：
```jsx
// 预加载 About 组件的函数
const preloadAbout = () => {
  import(''./pages/About'');
};

// 导航链接中添加预加载逻辑
<Link to="/about" onMouseEnter={preloadAbout}>关于我们</Link>
```

# 3. 关键注意事项
1. **`React.lazy` 仅支持默认导出**：若组件使用命名导出，需在动态导入时手动指定默认导出：
   ```jsx
   // 若 About 组件是命名导出：export const About = () => {...}
   const About = lazy(() => import(''./pages/About'').then(module => ({ default: module.About })));
   ```
2. **服务端渲染限制**：`React.lazy` 和 `Suspense` 仅支持客户端渲染（CSR），若项目使用服务端渲染（SSR），需使用 `loadable-components` 等第三方库替代。
3. **代码分割的粒度**：避免将过小的组件拆分为独立代码块（会增加网络请求次数），建议按路由级别进行分割（一个路由对应一个代码块）。
4. **fallback 内容设计**：占位符应简洁（如加载动画、文字），避免使用复杂组件（防止占位符本身加载耗时）。

# 4. 懒加载的优势
- 减小首屏 bundle 体积，提升首屏加载速度；
- 按需加载代码，节省用户流量（仅加载访问到的内容）；
- 降低服务器初始请求压力；
- 配合预加载策略，可兼顾首屏速度和后续页面加载速度。', '77b830a2-38dc-41a0-8e20-9f29ffc5a332', 'true', '2025-12-22 02:12:15.583964+00', '2025-12-23 02:53:33.20914+00'), ('e279e2e5-ea25-4766-8385-f56b5406c099', 'useCallback：缓存回调函数', '`useCallback` 是 React 中用于**缓存回调函数**的 Hook，核心作用是优化组件性能：避免因回调函数重新创建导致子组件不必要的重渲染。在 React 中，函数组件每次渲染时，内部定义的函数都会重新创建（生成新的引用），若将该函数作为 props 传递给子组件，即使子组件使用 `React.memo` 优化，也会因引用变化触发重渲染。`useCallback` 通过缓存函数引用，解决这一问题。

# 1. useCallback 核心原理与问题背景
## 1.1 问题背景：函数引用变化导致的重渲染
函数组件每次渲染时，内部的函数会重新创建（引用不同），例如：
```jsx
import { useState, memo } from ''react'';

// 子组件：使用 React.memo 优化，仅 props 变化时重渲染
const Child = memo(({ onClick }) => {
  console.log(''Child 组件重渲染'');
  return <button onClick={onClick}>子组件按钮</button>;
});

function Parent() {
  const [count, setCount] = useState(0);

  // 每次 Parent 渲染，都会创建新的 handleClick 函数（引用不同）
  const handleClick = () => {
    console.log(''按钮点击'');
  };

  return (
    <div>
      <p>count：{count}</p>
      <button onClick={() => setCount(prev => prev + 1)}>+1</button>
      {/* 每次 Parent 渲染，onClick 传递的函数引用不同，导致 Child 重渲染 */}
      <Child onClick={handleClick} />
    </div>
  );
}
```
上述代码中，点击“+1”按钮会触发 `Parent` 组件重渲染，`handleClick` 函数重新创建（引用变化），即使 `Child` 组件使用 `React.memo`，也会因 `onClick` props 变化而重渲染（但子组件的功能完全不需要依赖 `count` 状态），造成性能浪费。

## 1.2 useCallback 核心原理
`useCallback` 接收两个参数：
- 第一个参数：需要缓存的回调函数。
- 第二个参数：依赖项数组（与 `useEffect` 一致）。

返回值：缓存的函数引用（仅当依赖项变化时，才会返回新的函数引用；依赖项不变时，始终返回同一个函数引用）。

## 1.3 基本语法
```jsx
import { useCallback } from ''react'';

const cachedFunction = useCallback(() => {
  // 回调函数逻辑
  doSomething(dep1, dep2);
}, [dep1, dep2]); // 依赖项数组
```

# 2. useCallback 基础用法：解决不必要的重渲染
## 2.1 优化上述示例
使用 `useCallback` 缓存 `handleClick` 函数，仅当依赖项变化时才重新创建：
```jsx
import { useState, memo, useCallback } from ''react'';

const Child = memo(({ onClick }) => {
  console.log(''Child 组件重渲染'');
  return <button onClick={onClick}>子组件按钮</button>;
});

function Parent() {
  const [count, setCount] = useState(0);

  // 使用 useCallback 缓存函数，依赖项为空数组（无依赖）
  const handleClick = useCallback(() => {
    console.log(''按钮点击'');
  }, []); // 依赖项为空，函数引用永久缓存

  return (
    <div>
      <p>count：{count}</p>
      <button onClick={() => setCount(prev => prev + 1)}>+1</button>
      {/* 传递缓存的函数引用，Child 组件不会因 Parent 重渲染而重渲染 */}
      <Child onClick={handleClick} />
    </div>
  );
}
```
优化后，点击“+1”按钮时，`Parent` 组件重渲染，但 `handleClick` 函数引用不变，`Child` 组件不会重渲染，仅在首次渲染时执行一次。

## 2.2 带依赖项的 useCallback
若回调函数依赖于组件的 state 或 props，需将依赖项加入数组，确保函数能获取最新值：
```jsx
function Parent() {
  const [count, setCount] = useState(0);

  // 回调函数依赖 count，需加入依赖项数组
  const handleClick = useCallback(() => {
    console.log(''当前 count：'', count);
  }, [count]); // count 变化时，重新创建函数

  return <Child onClick={handleClick} />;
}
```
此时，仅当 `count` 变化时，`handleClick` 函数引用才会更新，`Child` 组件才会重渲染（符合预期）。

# 3. useCallback 的适用场景
## 场景1：传递给 memo 包装的子组件的回调函数
这是 `useCallback` 最核心的适用场景：子组件使用 `React.memo` 优化，且接收的 props 包含回调函数时，用 `useCallback` 缓存回调函数，避免子组件不必要的重渲染。

## 场景2：作为 useEffect/useLayoutEffect 的依赖项
若回调函数作为 `useEffect` 的依赖项，使用 `useCallback` 缓存函数，可避免因函数引用变化导致 `useEffect` 频繁执行：
```jsx
function MyComponent({ id }) {
  // 缓存回调函数
  const fetchData = useCallback(async () => {
    const res = await fetch(`/api/data/${id}`);
    const data = await res.json();
    setData(data);
  }, [id]); // 依赖 id

  // 仅当 fetchData 引用变化时（即 id 变化），执行 useEffect
  useEffect(() => {
    fetchData();
  }, [fetchData]); // 依赖缓存的函数

  // ...
}
```

## 场景3：作为自定义 Hook 的参数
自定义 Hook 若接收回调函数作为参数，使用 `useCallback` 缓存后传递，可避免自定义 Hook 内部不必要的逻辑执行：
```jsx
// 自定义 Hook：useEventListener
function useEventListener(eventName, handler, element = window) {
  // 缓存 handler，避免每次渲染重新添加监听
  const cachedHandler = useCallback(handler, [handler]);

  useEffect(() => {
    const isSupported = element && element.addEventListener;
    if (!isSupported) return;

    element.addEventListener(eventName, cachedHandler);
    return () => {
      element.removeEventListener(eventName, cachedHandler);
    };
  }, [eventName, element, cachedHandler]);
}

// 组件中使用
function MyComponent() {
  // 缓存回调函数，传递给自定义 Hook
  const handleResize = useCallback(() => {
    console.log(''窗口尺寸变化'');
  }, []);

  useEventListener(''resize'', handleResize);
  // ...
}
```

# 4. useCallback 的使用误区
## 误区1：滥用 useCallback（任何回调都缓存）
`useCallback` 本身有性能开销（需要维护缓存、对比依赖项），若回调函数不传递给子组件、也不作为 useEffect 依赖项，使用 `useCallback` 反而会增加性能负担：
```jsx
// 错误示例：不必要的 useCallback
function MyComponent() {
  // 回调函数仅在组件内部使用，无需缓存
  const handleClick = useCallback(() => {
    console.log(''内部按钮点击'');
  }, []);

  return <button onClick={handleClick}>内部按钮</button>;
}
```

## 误区2：依赖项缺失
若回调函数使用了 state/props，但未加入依赖项数组，会导致函数捕获旧值（闭包陷阱）：
```jsx
// 错误示例：依赖项缺失
function MyComponent() {
  const [count, setCount] = useState(0);

  const handleClick = useCallback(() => {
    console.log(''count：'', count); // 始终输出初始值 0
  }, []); // 缺失 count 依赖

  return (
    <div>
      <button onClick={() => setCount(prev => prev + 1)}>+1</button>
      <button onClick={handleClick}>打印 count</button>
    </div>
  );
}
```

## 误区3：忽略子组件的 React.memo
若子组件未使用 `React.memo` 优化，即使使用 `useCallback` 缓存回调函数，子组件仍会随父组件重渲染（`useCallback` 失去意义）：
```jsx
// 错误示例：子组件未使用 memo
const Child = ({ onClick }) => {
  console.log(''Child 重渲染'');
  return <button onClick={onClick}>子组件按钮</button>;
};

function Parent() {
  const handleClick = useCallback(() => {}, []);
  return <Child onClick={handleClick} />; // 子组件仍会重渲染
}
```

# 5. useCallback 与 useMemo 的关系
## 5.1 相似点
- 均用于性能优化，通过缓存减少不必要的计算/重渲染。
- 均接收依赖项数组，仅当依赖项变化时更新缓存。
- 均在组件渲染时执行（同步）。

## 5.2 区别
| 特性         | useCallback                      | useMemo                            |
|--------------|---------------------------------|------------------------------------|
| 缓存内容     | 函数引用                        | 函数执行结果                      |
| 返回值       | 缓存的函数（需调用才执行）| 缓存的计算结果（直接使用）|
| 适用场景     | 缓存回调函数（传递给子组件/依赖项） | 缓存复杂计算结果（避免重复计算）|
| 语法         | `useCallback(fn, deps)`         | `useMemo(() => fn(), deps)`        |

## 5.3 等价关系
`useCallback(fn, deps)` 等价于 `useMemo(() => fn, deps)`：
```jsx
// 两者完全等价
const cachedFn1 = useCallback(() => { /* ... */ }, [dep]);
const cachedFn2 = useMemo(() => () => { /* ... */ }, [dep]);
```

# 6. useCallback 最佳实践
## 6.1 仅在必要时使用
遵循“按需使用”原则：
- 回调函数传递给 `memo` 包装的子组件 → 使用 `useCallback`。
- 回调函数作为 `useEffect`/`useLayoutEffect` 的依赖项 → 使用 `useCallback`。
- 其他场景（如组件内部使用的回调）→ 无需使用。

## 6.2 正确设置依赖项
- 回调函数中使用的所有 state/props/变量，必须加入依赖项数组。
- 依赖项数组为空 → 函数永久缓存（仅创建一次）。
- 可使用 ESLint 规则 `react-hooks/exhaustive-deps` 检查依赖项是否完整。

## 6.3 结合 React.memo 使用
`useCallback` 必须与 `React.memo`（或 `PureComponent`）配合使用，否则无法实现性能优化。

## 6.4 避免缓存过于复杂的函数
`useCallback` 适合缓存简单回调函数，若函数内部逻辑复杂，建议拆分逻辑（如抽离为独立函数），避免缓存大函数带来的额外开销。

# 7. 核心总结
1. **核心作用**：缓存回调函数引用，避免因函数重新创建导致的子组件不必要重渲染或 useEffect 频繁执行。
2. **使用条件**：
   - 回调函数作为 props 传递给 `memo` 包装的子组件。
   - 回调函数作为 `useEffect`/`useLayoutEffect` 的依赖项。
3. **关键语法**：`useCallback(fn, deps)`，依赖项必须包含函数内使用的所有变量。
4. **使用误区**：
   - 滥用 `useCallback`（内部回调无需缓存）。
   - 依赖项缺失导致闭包陷阱。
   - 未配合 `React.memo` 使用。
5. **性能优化逻辑**：
   - 父组件重渲染 → 缓存的函数引用不变 → 子组件 props 不变 → 子组件不重渲染。...', 'aac29662-babe-4c96-8f61-0a16830155d4', 'true', '2025-12-19 15:16:32.190039+00', '2025-12-22 02:34:34.659078+00'), ('eba401ab-10dd-4f15-b870-357491915f78', 'Vite 搭建 React 项目', '# 1. Vite 核心特性与优势
Vite 是由尤雨溪开发的新一代前端构建工具，采用“按需编译”+“原生 ES 模块”的设计理念，核心优势体现在：
- **极速开发启动**：开发环境下无需打包，直接通过浏览器原生 ES 模块加载代码，启动时间通常在毫秒级（对比 CRA 的数十秒启动）；
- **热更新（HMR）高效**：仅更新修改的模块，而非全量刷新，大型项目中热更新速度远超传统打包工具；
- **开箱即用的优化**：内置对 TypeScript、JSX、CSS 预处理器的支持，无需额外配置；
- **生产环境优化**：基于 Rollup 打包，默认开启 Tree Shaking、代码分割、压缩等优化，打包体积更小。

# 2. Vite 搭建 React 项目步骤
## 2.1 初始化项目
确保已安装 Node.js（版本 ≥ 14.18.0），执行以下命令：
```bash
npm create vite@latest my-react-vite-project -- --template react

yarn create vite my-react-vite-project --template react

pnpm create vite my-react-vite-project -- --template react
```
- `--template react`：指定 React 模板（如需 TypeScript，使用 `react-ts` 模板）；
- 进入项目目录并安装依赖：
```bash
cd my-react-vite-project
npm install # 或 yarn / pnpm install
```

## 2.2 启动开发服务器
```bash
npm run dev # 开发环境
npm run build # 生产打包
npm run preview # 预览打包后的项目
```

# 3. Vite vs CRA（Create React App）核心对比
| 维度                | Vite                          | CRA（基于 Webpack）|
|---------------------|-------------------------------|---------------------------------|
| 启动速度            | 毫秒级（无需打包）| 数十秒（全量打包）|
| 热更新速度          | 即时更新（仅修改模块）| 随项目体积增大变慢              |
| 配置灵活性          | 支持通过 `vite.config.js` 自定义，配置简洁 | 需 eject 或使用 react-app-rewired 才能修改底层配置，配置复杂 |
| 内置功能            | 原生支持 TS、JSX、CSS 预处理器、静态资源 | 需手动安装插件支持 CSS 预处理器等 |
| 生产打包工具        | Rollup（更适合库/应用打包）| Webpack                        |
| 生态兼容性          | 兼容大部分 Webpack 插件（需适配）| 生态成熟，插件丰富              |
| 适用场景            | 中小型 React 项目、快速迭代开发 | 大型复杂项目、依赖 Webpack 生态  |

# 4. Vite 项目配置优化
Vite 配置文件为项目根目录的 `vite.config.js`（或 `vite.config.ts`），核心优化项如下：

## 4.1 基础配置（端口、代理、别名）
```javascript
import { defineConfig } from ''vite'';
import react from ''@vitejs/plugin-react'';
import path from ''path'';

export default defineConfig({
  // 插件
  plugins: [react()],
  // 开发服务器配置
  server: {
    port: 3000, // 自定义端口
    open: true, // 启动后自动打开浏览器
    proxy: {
      // 接口代理（解决跨域）
      ''/api'': {
        target: ''http://localhost:8080'',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api/, ''''),
      },
    },
  },
  // 路径别名（简化导入）
  resolve: {
    alias: {
      ''@'': path.resolve(__dirname, ''src''), // 用 @ 代替 src 目录
    },
  },
  // 生产环境构建配置
  build: {
    outDir: ''dist'', // 打包输出目录
    sourcemap: false, // 关闭生产环境 sourcemap（减小体积）
    rollupOptions: {
      // 代码分割优化
      output: {
        chunkFileNames: ''js/[name]-[hash].js'',
        entryFileNames: ''js/[name]-[hash].js'',
        assetFileNames: ''[ext]/[name]-[hash].[ext]'',
      },
    },
  },
});
```

## 4.2 CSS 优化（预处理器、模块化）
- 安装 CSS 预处理器（如 Sass）：
```bash
npm install -D sass
```
- 开启 CSS 模块化与自动导入：
```javascript
// vite.config.js
export default defineConfig({
  css: {
    modules: {
      localsConvention: ''camelCaseOnly'', // 类名转为驼峰命名
    },
    preprocessorOptions: {
      scss: {
        additionalData: ''@import "@/styles/variables.scss";'', // 全局导入变量
      },
    },
  },
});
```

## 4.3 依赖预构建优化
Vite 会预构建第三方依赖（如 React、Antd），可通过 `optimizeDeps` 配置：
```javascript
export default defineConfig({
  optimizeDeps: {
    include: [''react'', ''react-dom'', ''antd''], // 指定预构建依赖
    exclude: [''some-package''], // 排除无需预构建的依赖
  },
});
```

# 5. 常见问题解决
- **兼容性问题**：Vite 依赖原生 ES 模块，低版本浏览器需安装 `@vitejs/plugin-legacy` 插件；
- **第三方库兼容**：部分非 ES 模块的库需通过 `optimizeDeps` 预构建；
- **打包体积过大**：开启 `build.rollupOptions.output.manualChunks` 手动分割代码。', 'd8343213-03f7-4f4f-b6e3-6926e0f500a1', 'true', '2025-12-22 03:19:26.871848+00', '2025-12-23 13:17:03.180012+00'), ('ec51e174-f9b8-4912-a4de-2db39020706e', 'ESLint + Prettier 统一代码规范', '# 1. 核心价值与分工
在多人协作的 React 项目中，代码规范工具能解决以下问题：
- 避免语法错误、潜在 bug（如未定义变量、无效类型转换）；
- 统一代码风格（缩进、引号、分号等），降低维护成本；
- 强制遵循最佳实践（如 React 组件命名、Hook 使用规则）。

工具分工：
- **ESLint**：聚焦代码质量（语法正确性、逻辑合理性、最佳实践），支持自定义规则；
- **Prettier**：聚焦代码格式（缩进、换行、引号），无代码质量检查，格式化能力更强；
- 两者结合：ESLint 管“对不对”，Prettier 管“好不好看”。

# 2. 环境搭建
## 2.1 安装核心依赖
```bash
npm install -D eslint prettier

npm install -D eslint-config-prettier eslint-plugin-prettier

npm install -D eslint-plugin-react eslint-plugin-react-hooks eslint-plugin-react-refresh

npm install -D @typescript-eslint/eslint-plugin @typescript-eslint/parser
```

## 2.2 配置文件创建
### 2.2.1 ESLint 配置（.eslintrc.js / .eslintrc.json）
```javascript
// .eslintrc.js
module.exports = {
  // 环境：浏览器 + Node + ES2022 + React 18
  env: {
    browser: true,
    es2022: true,
    node: true,
  },
  // 解析器：TS 项目用 @typescript-eslint/parser，JS 项目用默认 espree
  parser: ''@typescript-eslint/parser'',
  // 解析器选项
  parserOptions: {
    ecmaVersion: ''latest'',
    sourceType: ''module'',
    ecmaFeatures: {
      jsx: true, // 支持 JSX
    },
  },
  // 插件
  plugins: [
    ''react'',
    ''react-hooks'',
    ''react-refresh'',
    ''@typescript-eslint'',
    ''prettier'',
  ],
  // 规则集（继承顺序：后序覆盖前序）
  extends: [
    ''eslint:recommended'', // ESLint 内置推荐规则
    ''plugin:@typescript-eslint/recommended'', // TS 推荐规则
    ''plugin:react/recommended'', // React 推荐规则
    ''plugin:react-hooks/recommended'', // React Hooks 规则
    ''plugin:prettier/recommended'', // Prettier 集成（开启 prettier 规则，禁用 ESLint 格式规则）
    ''prettier'', // 禁用所有与 Prettier 冲突的 ESLint 规则
  ],
  // 自定义规则
  rules: {
    // React 相关
    ''react/react-in-jsx-scope'': ''off'', // React 17+ 无需导入 React
    ''react/prop-types'': ''off'', // TS 项目用类型定义替代 PropTypes
    ''react-refresh/only-export-components'': ''warn'', // 仅导出组件（避免热更新失效）
    // React Hooks 强制规则
    ''react-hooks/rules-of-hooks'': ''error'', // 检查 Hooks 使用规则
    ''react-hooks/exhaustive-deps'': ''warn'', // 检查依赖数组完整性
    // TS 相关
    ''@typescript-eslint/no-unused-vars'': [''error'', { argsIgnorePattern: ''^_'' }], // 未使用变量报错（忽略下划线开头参数）
    ''@typescript-eslint/no-explicit-any'': ''warn'', // 避免使用 any 类型
    // Prettier 相关
    ''prettier/prettier'': ''error'', // Prettier 格式化错误视为 ESLint 错误
    // 通用规则
    ''no-console'': process.env.NODE_ENV === ''production'' ? ''error'' : ''warn'', // 生产环境禁止 console
    ''no-debugger'': process.env.NODE_ENV === ''production'' ? ''error'' : ''off'', // 生产环境禁止 debugger
  },
  // 全局变量
  globals: {
    React: ''readonly'',
  },
  // React 版本自动检测
  settings: {
    react: {
      version: ''detect'',
    },
  },
};
```

### 2.2.2 Prettier 配置（.prettierrc.js / .prettierrc）
```javascript
// .prettierrc.js
module.exports = {
  printWidth: 100, // 每行最大字符数
  tabWidth: 2, // 缩进空格数
  useTabs: false, // 使用空格而非制表符
  singleQuote: true, // 使用单引号
  semi: true, // 语句末尾加分号
  trailingComma: ''es5'', // 多行对象/数组最后一个元素加逗号（ES5 兼容）
  bracketSpacing: true, // 对象字面量括号两侧加空格（{ foo: bar }）
  arrowParens: ''avoid'', // 箭头函数单个参数省略括号
  endOfLine: ''lf'', // 换行符使用 LF
  jsxSingleQuote: true, // JSX 中使用单引号
  bracketSameLine: false, // JSX 标签闭合括号换行
};
```

### 2.2.3 忽略文件（.eslintignore / .prettierignore）
```
# .eslintignore & .prettierignore 通用内容
node_modules/
dist/
build/
coverage/
*.config.js
*.d.ts
public/
```

### 2.2.4 package.json 脚本配置
```json
{
  "scripts": {
    "lint": "eslint . --ext .js,.jsx,.ts,.tsx", // 检查代码
    "lint:fix": "eslint . --ext .js,.jsx,.ts,.tsx --fix", // 自动修复可修复问题
    "format": "prettier --write \"**/*.{js,jsx,ts,tsx,json,css,md}\"" // 格式化所有文件
  }
}
```

# 3. 关键规则说明
## 3.1 React 核心规则
| 规则 | 作用 | 推荐配置 |
|------|------|----------|
| `react/react-in-jsx-scope` | 强制 JSX 文件导入 React | React 17+ 设为 `off` |
| `react-hooks/rules-of-hooks` | 强制 Hooks 只能在组件/自定义 Hooks 中调用 | `error` |
| `react-hooks/exhaustive-deps` | 检查 useEffect 等 Hooks 依赖数组完整性 | `warn` |
| `react-refresh/only-export-components` | 避免组件文件导出非组件内容（影响热更新） | `warn` |

## 3.2 Prettier 核心规则
| 规则 | 作用 | 团队协作建议 |
|------|------|--------------|
| `singleQuote` | 单引号/双引号 | 统一设为 `true`（JS 生态更常用单引号） |
| `trailingComma` | 多行末尾逗号 | 设为 `es5`（兼容旧环境，避免语法错误） |
| `printWidth` | 每行最大字符数 | 设为 80/100（根据团队习惯） |

# 4. 编辑器集成（VS Code）
1. 安装插件：ESLint、Prettier - Code formatter；
2. 配置 settings.json（用户/工作区）：
   ```json
   {
     "editor.formatOnSave": true, // 保存时自动格式化
     "editor.defaultFormatter": "esbenp.prettier-vscode", // 默认格式化工具为 Prettier
     "editor.codeActionsOnSave": {
       "source.fixAll.eslint": true // 保存时自动修复 ESLint 问题
     },
     "eslint.validate": ["javascript", "javascriptreact", "typescript", "typescriptreact"]
   }
   ```

# 5. 常见问题解决
## 5.1 ESLint 与 Prettier 规则冲突
- 原因：ESLint 部分格式规则（如 `indent`、`quotes`）与 Prettier 冲突；
- 解决：通过 `eslint-config-prettier` 禁用冲突规则，`eslint-plugin-prettier` 将 Prettier 规则转为 ESLint 规则。

## 5.2 TS 项目中 ESLint 不识别 TS 类型
- 安装 `@typescript-eslint/parser` 和 `@typescript-eslint/eslint-plugin`；
- 确保 `parserOptions.project` 指向 `tsconfig.json`（如需类型检查规则）：
  ```javascript
  // .eslintrc.js
  parserOptions: {
    project: ''./tsconfig.json'', // 启用类型检查规则需配置
  },
  ```

## 5.3 自动修复不生效
- 检查文件是否在 `.eslintignore` 中；
- 确认规则是否支持自动修复（ESLint 规则文档中标注 `fixable`）；
- 重启 VS Code ESLint 服务（Ctrl+Shift+P → ESLint: Restart ESLint Server）。

# 6. 进阶配置（可选）
## 6.1 提交前自动校验（husky + lint-staged）
避免不合规代码提交到仓库：
```bash
npm install -D husky lint-staged
npx husky install
npx husky add .husky/pre-commit "npx lint-staged"
```

配置 `package.json`：
```json
{
  "lint-staged": {
    "*.{js,jsx,ts,tsx}": ["eslint --fix", "prettier --write"],
    "*.{json,css,md}": ["prettier --write"]
  }
}
```

## 6.2 自定义 ESLint 规则
创建共享规则包或在项目中扩展规则：
```javascript
// .eslintrc.js
rules: {
  // 自定义规则：强制组件文件名使用 PascalCase
  "react/jsx-filename-extension": ["error", { extensions: [".tsx"] }],
  "react/function-component-definition": ["error", {
    "namedComponents": "function-declaration" // 强制组件使用函数声明
  }]
}
```', '4e45758d-1053-4937-b961-5a3cef9e566a', 'true', '2025-12-22 03:20:44.180687+00', '2025-12-23 13:55:43.370909+00'), ('f8103d18-4ed0-4746-acf7-b65119460f76', '组件测试实战', '# 1. 渲染测试（基础渲染/条件渲染/列表渲染）
## 1.1 基础渲染测试
验证组件是否正常渲染所有核心元素：
```tsx
// UserCard.tsx
import React from ''react'';

interface UserCardProps {
  name: string;
  age: number;
  avatar?: string;
}

const UserCard = ({ name, age, avatar }: UserCardProps) => {
  return (
    <div className="user-card">
      {avatar && <img src={avatar} alt={name} data-testid="avatar" />}
      <h3>{name}</h3>
      <p>年龄：{age}</p>
    </div>
  );
};

export default UserCard;

// UserCard.test.tsx
import React from ''react'';
import { render, screen } from ''@testing-library/react'';
import UserCard from ''./UserCard'';

test(''UserCard 渲染基础信息'', () => {
  // 渲染组件
  render(<UserCard name="张三" age={20} />);
  
  // 验证名称和年龄显示
  expect(screen.getByText(''张三'')).toBeInTheDocument();
  expect(screen.getByText(''年龄：20'')).toBeInTheDocument();
  
  // 验证头像不存在（未传递 avatar 属性）
  expect(screen.queryByTestId(''avatar'')).not.toBeInTheDocument();
});

test(''UserCard 渲染头像（当传递 avatar 时）'', () => {
  render(<UserCard name="李四" age={25} avatar="https://example.com/avatar.jpg" />);
  
  // 验证头像存在且属性正确
  const avatar = screen.getByTestId(''avatar'');
  expect(avatar).toBeInTheDocument();
  expect(avatar).toHaveAttribute(''src'', ''https://example.com/avatar.jpg'');
  expect(avatar).toHaveAttribute(''alt'', ''李四'');
});
```

## 1.2 条件渲染测试
验证组件在不同条件下的渲染结果：
```tsx
// LoginStatus.tsx
import React from ''react'';

interface LoginStatusProps {
  isLogin: boolean;
  username: string;
}

const LoginStatus = ({ isLogin, username }: LoginStatusProps) => {
  if (isLogin) {
    return <div>欢迎回来，{username}！</div>;
  } else {
    return <button>请登录</button>;
  }
};

export default LoginStatus;

// LoginStatus.test.tsx
import React from ''react'';
import { render, screen } from ''@testing-library/react'';
import LoginStatus from ''./LoginStatus'';

test(''已登录时显示欢迎信息'', () => {
  render(<LoginStatus isLogin={true} username="张三" />);
  expect(screen.getByText(/欢迎回来，张三！/i)).toBeInTheDocument();
  expect(screen.queryByRole(''button'')).not.toBeInTheDocument();
});

test(''未登录时显示登录按钮'', () => {
  render(<LoginStatus isLogin={false} username="" />);
  expect(screen.getByRole(''button'', { name: /请登录/i })).toBeInTheDocument();
  expect(screen.queryByText(/欢迎回来/i)).not.toBeInTheDocument();
});
```

## 1.3 列表渲染测试
验证列表组件是否正确渲染所有项：
```tsx
// TodoList.tsx
import React from ''react'';

interface Todo {
  id: number;
  text: string;
  done: boolean;
}

interface TodoListProps {
  todos: Todo[];
}

const TodoList = ({ todos }: TodoListProps) => {
  if (todos.length === 0) {
    return <div>暂无待办事项</div>;
  }
  return (
    <ul>
      {todos.map((todo) => (
        <li key={todo.id} className={todo.done ? ''done'' : ''''}>
          {todo.text}
        </li>
      ))}
    </ul>
  );
};

export default TodoList;

// TodoList.test.tsx
import React from ''react'';
import { render, screen } from ''@testing-library/react'';
import TodoList from ''./TodoList'';

const mockTodos = [
  { id: 1, text: ''学习 React 测试'', done: false },
  { id: 2, text: ''完成作业'', done: true },
];

test(''TodoList 渲染所有待办事项'', () => {
  render(<TodoList todos={mockTodos} />);
  
  // 验证两个待办项都存在
  expect(screen.getByText(''学习 React 测试'')).toBeInTheDocument();
  expect(screen.getByText(''完成作业'')).toBeInTheDocument();
  
  // 验证已完成项的 className
  const doneItem = screen.getByText(''完成作业'').closest(''li'');
  expect(doneItem).toHaveClass(''done'');
});

test(''TodoList 无数据时显示提示文本'', () => {
  render(<TodoList todos={[]} />);
  expect(screen.getByText(''暂无待办事项'')).toBeInTheDocument();
});
```

# 2. 事件测试（点击/输入/表单提交）
## 2.1 点击事件测试
模拟按钮点击、复选框切换等点击行为：
```tsx
// ToggleButton.tsx
import React, { useState } from ''react'';

const ToggleButton = () => {
  const [isOn, setIsOn] = useState(false);
  
  const toggle = () => {
    setIsOn(!isOn);
  };
  
  return (
    <button onClick={toggle}>
      {isOn ? ''开启'' : ''关闭''}
    </button>
  );
};

export default ToggleButton;

// ToggleButton.test.tsx
import React from ''react'';
import { render, screen } from ''@testing-library/react'';
import userEvent from ''@testing-library/user-event'';
import ToggleButton from ''./ToggleButton'';

test(''ToggleButton 点击切换状态'', async () => {
  const user = userEvent.setup();
  render(<ToggleButton />);
  
  // 初始状态为“关闭”
  let button = screen.getByRole(''button'', { name: /关闭/i });
  expect(button).toBeInTheDocument();
  
  // 模拟点击
  await user.click(button);
  
  // 状态切换为“开启”
  button = screen.getByRole(''button'', { name: /开启/i });
  expect(button).toBeInTheDocument();
  
  // 再次点击切换回“关闭”
  await user.click(button);
  expect(screen.getByRole(''button'', { name: /关闭/i })).toBeInTheDocument();
});
```

## 2.2 输入事件测试
模拟输入框、下拉框等输入行为：
```tsx
// SearchInput.tsx
import React, { useState } from ''react'';

interface SearchInputProps {
  onSearch: (value: string) => void;
}

const SearchInput = ({ onSearch }: SearchInputProps) => {
  const [value, setValue] = useState('''');
  
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setValue(e.target.value);
  };
  
  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onSearch(value);
  };
  
  return (
    <form onSubmit={handleSubmit}>
      <input
        type="text"
        placeholder="请输入搜索内容"
        value={value}
        onChange={handleChange}
        aria-label="搜索框"
      />
      <button type="submit">搜索</button>
    </form>
  );
};

export default SearchInput;

// SearchInput.test.tsx
import React from ''react'';
import { render, screen } from ''@testing-library/react'';
import userEvent from ''@testing-library/user-event'';
import SearchInput from ''./SearchInput'';

test(''SearchInput 输入内容并提交'', async () => {
  const user = userEvent.setup();
  const mockSearch = jest.fn();
  
  render(<SearchInput onSearch={mockSearch} />);
  
  // 获取输入框和提交按钮
  const input = screen.getByLabelText(''搜索框'');
  const submitButton = screen.getByRole(''button'', { name: /搜索/i });
  
  // 模拟输入内容
  await user.type(input, ''React 测试'');
  expect(input).toHaveValue(''React 测试'');
  
  // 模拟提交表单
  await user.click(submitButton);
  
  // 验证回调被调用，且参数正确
  expect(mockSearch).toHaveBeenCalledTimes(1);
  expect(mockSearch).toHaveBeenCalledWith(''React 测试'');
});

test(''SearchInput 空内容提交不触发回调'', async () => {
  const user = userEvent.setup();
  const mockSearch = jest.fn();
  
  render(<SearchInput onSearch={mockSearch} />);
  
  // 直接提交空表单
  await user.click(screen.getByRole(''button'', { name: /搜索/i }));
  
  // 验证回调未被调用
  expect(mockSearch).not.toHaveBeenCalled();
});
```

# 3. 异步测试（接口请求/定时器/状态延迟更新）
## 3.1 接口请求模拟测试
使用 Jest Mock 模拟接口请求，测试异步组件：
```tsx
// UserList.tsx
import React, { useEffect, useState } from ''react'';

interface User {
  id: number;
  name: string;
}

// 模拟接口请求
const fetchUsers = async (): Promise<User[]> => {
  const res = await fetch(''/api/users'');
  return res.json();
};

const UserList = () => {
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('''');
  
  useEffect(() => {
    const loadUsers = async () => {
      try {
        const data = await fetchUsers();
        setUsers(data);
      } catch (err) {
        setError(''加载用户失败'');
      } finally {
        setLoading(false);
      }
    };
    
    loadUsers();
  }, []);
  
  if (loading) {
    return <div>加载中...</div>;
  }
  
  if (error) {
    return <div className="error">{error}</div>;
  }
  
  return (
    <ul>
      {users.map((user) => (
        <li key={user.id}>{user.name}</li>
      ))}
    </ul>
  );
};

export default UserList;

// UserList.test.tsx
import React from ''react'';
import { render, screen, waitFor } from ''@testing-library/react'';
import UserList from ''./UserList'';

// Mock 整个模块的 fetchUsers 函数
jest.mock(''./UserList'', () => {
  const original = jest.requireActual(''./UserList'');
  return {
    ...original,
    fetchUsers: jest.fn(),
  };
});

const mockFetchUsers = jest.mocked(require(''./UserList'').fetchUsers);

test(''UserList 加载成功显示用户列表'', async () => {
  // 模拟接口返回数据
  const mockUsers = [{ id: 1, name: ''张三'' }, { id: 2, name: ''李四'' }];
  mockFetchUsers.mockResolvedValue(mockUsers);
  
  render(<UserList />);
  
  // 验证加载中状态
  expect(screen.getByText(''加载中...'')).toBeInTheDocument();
  
  // 等待异步加载完成，验证用户列表显示
  await waitFor(() => {
    expect(screen.getByText(''张三'')).toBeInTheDocument();
    expect(screen.getByText(''李四'')).toBeInTheDocument();
  });
  
  // 验证加载中状态消失
  expect(screen.queryByText(''加载中...'')).not.toBeInTheDocument();
});

test(''UserList 加载失败显示错误信息'', async () => {
  // 模拟接口抛出错误
  mockFetchUsers.mockRejectedValue(new Error(''Network Error''));
  
  render(<UserList />);
  
  // 等待错误状态显示
  await waitFor(() => {
    expect(screen.getByText(''加载用户失败'')).toBeInTheDocument();
  });
});
```

## 3.2 定时器模拟测试
使用 Jest 定时器模拟功能测试延迟更新组件：
```tsx
// Countdown.tsx
import React, { useState, useEffect } from ''react'';

const Countdown = ({ initial = 3 }: { initial?: number }) => {
  const [count, setCount] = useState(initial);
  
  useEffect(() => {
    if (count > 0) {
      const timer = setTimeout(() => {
        setCount(count - 1);
      }, 1000);
      return () => clearTimeout(timer);
    }
  }, [count]);
  
  return <div>{count === 0 ? ''倒计时结束'' : `倒计时：${count}`}</div>;
};

export default Countdown;

// Countdown.test.tsx
import React from ''react'';
import { render, screen } from ''@testing-library/react'';
import Countdown from ''./Countdown'';

// 启用 Jest 定时器模拟
jest.useFakeTimers();

test(''Countdown 倒计时功能正常'', () => {
  render(<Countdown initial={2} />);
  
  // 初始状态：倒计时 2
  expect(screen.getByText(''倒计时：2'')).toBeInTheDocument();
  
  // 快进所有定时器
  jest.runAllTimers();
  
  // 第一次倒计时：1
  expect(screen.getByText(''倒计时：1'')).toBeInTheDocument();
  
  // 再次快进定时器
  jest.runAllTimers();
  
  // 倒计时结束
  expect(screen.getByText(''倒计时结束'')).toBeInTheDocument();
});

test(''Countdown 清理定时器（避免内存泄漏）'', () => {
  const { unmount } = render(<Countdown initial={3} />);
  
  // 模拟组件卸载
  unmount();
  
  // 验证定时器被清除
  expect(jest.clearAllTimers).toHaveBeenCalledTimes(1);
});

// 恢复真实定时器
jest.useRealTimers();
```

# 4. 特殊场景测试
## 4.1 模态框测试
测试模态框的显示/隐藏逻辑：
```tsx
// Modal.tsx
import React from ''react'';
import ReactDOM from ''react-dom'';

interface ModalProps {
  isOpen: boolean;
  onClose: () => void;
  children: React.ReactNode;
}

const Modal = ({ isOpen, onClose, children }: ModalProps) => {
  if (!isOpen...', 'a563f346-3dac-4331-b926-8587cb32b144', 'true', '2025-12-22 03:20:34.053001+00', '2025-12-23 13:45:02.92106+00'), ('faabe940-bda7-40c4-8247-1398f3826401', 'Zustand 最佳实践', '在掌握 Zustand 基础用法和核心特性后，本文将聚焦“工程化实践”，涵盖 Store 模块化拆分、TypeScript 类型提示、性能优化技巧，帮助你在实际项目中规范使用 Zustand，兼顾可维护性和运行效率。

# 1. 模块化拆分：按业务拆分 Store
随着项目规模扩大，将所有状态放在一个 Store 中会导致代码臃肿、维护困难。最佳实践是**按业务领域拆分独立 Store**，每个 Store 负责管理特定模块的状态（如用户模块、购物车模块、全局设置模块）。

## 1.1 模块化拆分原则
- 单一职责：一个 Store 只管理一个业务模块的状态（如 `userStore` 仅管用户相关，`cartStore` 仅管购物车相关）；
- 低耦合：Store 之间尽量独立，若需跨 Store 访问，优先通过“组件中转”或“组合状态”，避免直接依赖；
- 统一目录：所有 Store 放在 `src/stores` 目录下，按模块命名（如 `userStore.ts`、`cartStore.ts`）。

## 1.2 模块化示例
### （1）用户模块 Store（stores/userStore.ts）
```tsx
import { create } from ''zustand'';
import { persist } from ''zustand/middleware'';

// 定义用户状态类型（TypeScript）
interface UserState {
  userInfo: { id: number; name: string; avatar: string } | null;
  token: string;
  loading: boolean;
  login: (token: string, user: UserState[''userInfo'']) => void;
  logout: () => void;
  fetchUserInfo: (userId: number) => Promise<void>;
}

const useUserStore = create<UserState>()(
  persist(
    (set) => ({
      userInfo: null,
      token: '''',
      loading: false,

      login: (token, user) => set({ token, userInfo: user }),
      logout: () => set({ token: '''', userInfo: null }),

      fetchUserInfo: async (userId) => {
        set({ loading: true });
        try {
          const res = await fetch(`/api/users/${userId}`);
          const data = await res.json();
          set({ userInfo: data, loading: false });
        } catch (err) {
          set({ loading: false });
          console.error(''获取用户信息失败：'', err);
        }
      },
    }),
    { name: ''user-storage'' }
  )
);

export default useUserStore;
```

### （2）购物车模块 Store（stores/cartStore.ts）
```tsx
import { create } from ''zustand'';
import { persist } from ''zustand/middleware'';

// 购物车商品类型
interface CartItem {
  id: number;
  name: string;
  price: number;
  quantity: number;
}

// 购物车状态类型
interface CartState {
  items: CartItem[];
  addItem: (item: Omit<CartItem, ''quantity''>) => void;
  removeItem: (itemId: number) => void;
  updateQuantity: (itemId: number, quantity: number) => void;
  clearCart: () => void;
  totalPrice: () => number; // 计算总价（衍生状态）
}

const useCartStore = create<CartState>()(
  persist(
    (set, get) => ({
      items: [],

      // 添加商品（已存在则增加数量，否则新增）
      addItem: (item) =>
        set((state) => {
          const existingItem = state.items.find((i) => i.id === item.id);
          if (existingItem) {
            return {
              items: state.items.map((i) =>
                i.id === item.id ? { ...i, quantity: i.quantity + 1 } : i
              ),
            };
          }
          return { items: [...state.items, { ...item, quantity: 1 }] };
        }),

      // 移除商品
      removeItem: (itemId) =>
        set((state) => ({
          items: state.items.filter((i) => i.id !== itemId),
        })),

      // 更新商品数量
      updateQuantity: (itemId, quantity) =>
        set((state) => ({
          items: state.items.map((i) =>
            i.id === itemId ? { ...i, quantity: Math.max(1, quantity) } : i
          ),
        })),

      // 清空购物车
      clearCart: () => set({ items: [] }),

      // 衍生状态：计算总价（通过 get() 获取当前状态）
      totalPrice: () => {
        const items = get().items;
        return items.reduce((sum, item) => sum + item.price * item.quantity, 0);
      },
    }),
    { name: ''cart-storage'' }
  )
);

export default useCartStore;
```

### （3）组件中使用多个模块 Store
```tsx
import useUserStore from ''../stores/userStore'';
import useCartStore from ''../stores/cartStore'';

export default function CartPage() {
  // 从 userStore 获取用户信息
  const { userInfo, login } = useUserStore((state) => ({
    userInfo: state.userInfo,
    login: state.login,
  }));

  // 从 cartStore 获取购物车状态和方法
  const { items, addItem, totalPrice } = useCartStore((state) => ({
    items: state.items,
    addItem: state.addItem,
    totalPrice: state.totalPrice,
  }));

  return (
    <div>
      {!userInfo ? (
        <button onClick={() => login(''fake-token'', { id: 1, name: ''张三'', avatar: '''' })}>
          登录后查看购物车
        </button>
      ) : (
        <div>
          <h2>购物车（{items.length} 件商品）</h2>
          <ul>
            {items.map((item) => (
              <li key={item.id}>
                {item.name} - ￥{item.price} × {item.quantity}
              </li>
            ))}
          </ul>
          <p>总价：￥{totalPrice()}</p>
          <button onClick={() => addItem({ id: 3, name: ''手机'', price: 3999 })}>
            添加商品
          </button>
        </div>
      )}
    </div>
  );
}
```

## 1.3 跨 Store 通信（可选）
若两个 Store 需相互依赖（如购物车结算时需获取用户地址），推荐以下两种方式：
- 方式 1：组件中转（推荐）：在组件中同时获取两个 Store 的状态和方法，通过组件逻辑关联；
- 方式 2：Store 内部引用：在一个 Store 中通过 `get` 函数获取另一个 Store 的状态（需注意循环依赖）：
  ```tsx
  // cartStore 中获取 userStore 的状态
  import useUserStore from ''./userStore'';

  const useCartStore = create((set, get) => ({
    // 结算时获取用户地址
    checkout: () => {
      const userAddress = useUserStore.getState().userInfo?.address;
      if (!userAddress) throw new Error(''请先完善收货地址'');
      // 结算逻辑...
    },
  }));
  ```

# 2. TypeScript 类型提示：提升开发效率与类型安全
Zustand 原生支持 TypeScript，通过定义状态接口（Interface），可实现全链路类型提示，避免类型错误。以下是完整的 TypeScript 实践方案。

## 2.1 核心类型定义规范
- 为每个 Store 定义单独的状态接口（如 `UserState`、`CartState`），包含“状态字段”和“方法类型”；
- 方法类型需明确参数类型和返回值类型（尤其是异步方法，需指定 `Promise` 类型）；
- 使用 `create<StateInterface>()` 泛型语法绑定类型，确保 `set`、`get` 函数的类型推导正确。

## 2.2 类型提示示例（完整版）
```tsx
import { create } from ''zustand'';
import { devtools, persist } from ''zustand/middleware'';

// 1. 定义子类型（如商品类型、用户信息类型）
interface Product {
  id: number;
  name: string;
  price: number;
  stock: number;
}

// 2. 定义 Store 状态接口
interface ProductState {
  products: Product[];
  loading: boolean;
  error: string | null;
  // 同步方法：参数类型 + 返回值类型（void 可省略）
  setLoading: (loading: boolean) => void;
  // 异步方法：返回 Promise<void>
  fetchProducts: (category?: string) => Promise<void>;
  // 带参数的同步方法
  updateStock: (productId: number, stock: number) => void;
}

// 3. 创建 Store 并绑定类型
const useProductStore = create<ProductState>()(
  devtools(
    persist(
      (set, get) => ({
        products: [],
        loading: false,
        error: null,

        setLoading: (loading) => set({ loading }), // 自动推导参数类型

        fetchProducts: async (category) => {
          get().setLoading(true);
          try {
            const url = category 
              ? `/api/products?category=${category}` 
              : ''/api/products'';
            const res = await fetch(url);
            if (!res.ok) throw new Error(''请求失败'');
            const data: Product[] = await res.json(); // 类型断言
            set({ products: data, error: null });
          } catch (err) {
            set({ error: err instanceof Error ? err.message : ''未知错误'' });
          } finally {
            get().setLoading(false);
          }
        },

        updateStock: (productId, stock) => {
          set((state) => ({
            products: state.products.map((p) =>
              p.id === productId ? { ...p, stock } : p
            ),
          }));
        },
      }),
      { name: ''product-storage'' }
    )
  )
);

export default useProductStore;
```

## 2.3 类型提示优势
- 状态字段自动补全：在组件中通过 `useStore` 获取状态时，IDE 会自动提示所有可用字段和方法；
- 类型错误提前暴露：若传递错误类型的参数（如给 `updateStock` 传递字符串类型的 `stock`），TypeScript 会编译报错；
- 方法返回值类型推导：异步方法自动提示 `await` 语法，避免忘记处理 Promise；
- 状态不可变性保障：通过类型定义限制状态字段的修改方式，避免直接修改状态。

## 2.4 常见类型问题解决方案
- **可选参数类型**：异步方法的可选参数需显式指定（如 `category?: string`）；
- **联合类型**：若状态字段支持多种类型（如 `error: string | null`），需明确声明联合类型；
- **类型断言**：从接口请求的数据需通过类型断言（`as Product[]`）绑定类型，确保数据结构正确；
- **持久化状态类型**：持久化的状态需支持 JSON 序列化（避免包含 `Date`、`Function` 等类型，若需存储 `Date`，需手动转换为字符串）。

# 3. 性能优化：避免不必要的重渲染
Zustand 本身性能优异（基于订阅-发布模式，仅依赖状态变化的组件会重渲染），但不合理的使用仍可能导致性能问题。以下是关键优化技巧。

## 3.1 精准选择状态：避免“过度订阅”
- 错误用法：获取整个 Store 或无关状态，导致组件因无关状态变化而重渲染；
- 正确用法：仅获取组件所需的单个状态或部分状态，配合 `shallow` 比较优化多状态获取。

```tsx
// 错误：获取整个 Store，任意状态变化都会重渲染
const store = useProductStore();

// 正确：仅获取需要的状态（单个状态）
const products = useProductStore((state) => state.products);
const loading = useProductStore((state) => state.loading);

// 正确：获取多个状态时使用 shallow 比较
import { shallow } from ''zustand/shallow'';
const { products, loading } = useProductStore(
  (state) => ({ products: state.products, loading: state.loading }),
  shallow // 仅当 products 或 loading 实际变化时重渲染
);
```

## 3.2 衍生状态：避免重复计算
若组件需要基于 Store 状态计算衍生值（如购物车总价、商品数量），推荐在 Store 中定义衍生状态方法，避免在组件中重复计算。

```tsx
// 推荐：在 Store 中定义衍生状态方法
const useCartStore = create((set, get) => ({
  items: [],
  // 衍生状态：计算总价（仅当 items 变化时重新计算）
  totalPrice: () => {
    return get().items.reduce((sum, item) => sum + item.price * item.quantity, 0);
  },
}));

// 组件中直接调用，无需重复计算
const totalPrice = useCartStore((state) => state.totalPrice);
<p>总价：￥{totalPrice()}</p>;
```

## 3.3 避免在选择器中创建新对象/函数
选择器函数返回新对象、数组或函数时，会导致每次渲染都生成新引用，Zustand 会误判为“状态变化”，触发不必要的重渲染。

```tsx
// 错误：每次渲染返回新数组，导致组件频繁重渲染
const activeProducts = useProductStore((state) => 
  state.products.filter((p) => p.stock > 0) // 每次返回新数组
);

// 正确：优化方案1 - 在 Store 中定义筛选后的状态
const useProductStore = create((set, get) => ({
  products: [],
  // 存储筛选后的状态，仅当 products 变化时更新
  activeProducts: [],
  updateActiveProducts: () => {
    const active = get().products.filter((p) => p.stock > 0);
    set({ activeProducts: active });
  },
}));

// 正确：优化方案2 - 使用 memo 缓存组件（适用于简单场景）
import { memo } from ''react'';
const ActiveProducts = memo(() => {
  const products = useProductStore((state) => state.products);
  const activeProducts = products.filter((p) => p.stock > 0); // 组件内部计算，memo 避免重渲染
  return <div>{activeProducts.map((p) => p.name)}</div>;
});
```

## 3.4 批量更新状态
若需同时修改多个状态，尽量在一个 `set` 函数中完成，避免多次调用 `set` 导致组件多次重渲染。

```tsx
// 优化前：多次调用 set，组件可能重渲染多次
const updateUser = () => {
  set({ name: ''李四'' });
  set({ age: 25 });
  set({ address: ''上海'' });
};

// 优化后：一次 set 批量更新，组件仅重渲染一次
const updateUser = () => {
  set({ name: ''李四'', age: 25, address: ''上海'' });
};
```

## 3.5 防抖/节流状态更新
若状态更新触发频繁（如输入框实时搜索），可对状态方法进行防抖/节流处理，减少不必要的接口请求和状态更新。

```tsx
import { create } from ''zustand'';
import { debounce } from ''lodash''; // 需安装 lodash：npm install lodash

const useSearchStore = create((set) => ({
  keyword: '''',
  searchResult: [],
  loading: false,

  // 防抖处理：输入停止 500ms 后再触发搜索
  search: debounce(async (keyword) => {
    set({ loading: true });
    try {
      const res = await fetch(`/api/search?keyword=${keyword}`);
      const data = await ...', 'ed2cdaf2-c966-4d9f-bfad-740b9f352c61', 'true', '2025-12-22 03:10:53.057773+00', '2025-12-23 03:15:58.614524+00'), ('fb483696-bad2-475f-af69-f5ced7edc43c', 'Redux Toolkit', 'Redux 原生用法存在**样板代码冗余**（如手动定义 Action 类型、组合 Reducer、处理不可变状态）、**不可变操作繁琐**（需手动扩展对象/数组）等问题，Redux Toolkit（RTK）是官方推荐的“一站式解决方案”，内置常用工具（如 `createSlice`、`configureStore`），大幅简化开发流程。

# 1. 核心优势
- 内置 `immer` 库，支持“可变写法”实现不可变状态（无需手动扩展运算符）；
- 自动生成 Action 类型和 Action 创建函数；
- 简化 Store 配置（内置中间件、支持开发者工具）；
- 集成常用功能（如异步请求处理、状态持久化）。

# 2. 快速上手：安装 Redux Toolkit
```bash
npm install @reduxjs/toolkit react-redux

yarn add @reduxjs/toolkit react-redux
```

# 3. createSlice：一站式定义 Reducer 和 Action
`createSlice` 是 RTK 的核心 API，用于封装“状态初始值 + Reducer 逻辑 + Action 创建”，自动生成唯一的 Action 类型和对应的 Action 创建函数。

## 3.1 语法：
```javascript
import { createSlice } from ''@reduxjs/toolkit'';

const slice = createSlice({
  name: ''slice名称'', // 作为 Action 类型的前缀（如 "todo/addTodo"）
  initialState: 初始状态, // 模块初始状态
  reducers: {
    // 定义 Reducer 函数（支持“可变写法”，immer 自动转换为不可变状态）
    函数名: (state, action) => {
      // 直接修改 state（immer 处理不可变性）
    }
  }
});

// 自动生成的 Action 创建函数
export const { 函数名1, 函数名2 } = slice.actions;

// 导出 Reducer（用于组合根 Reducer）
export default slice.reducer;
```

## 3.2 示例：创建 Todo Slice
```javascript
import { createSlice } from ''@reduxjs/toolkit'';

// 初始状态
const initialState = {
  todos: []
};

// 创建 Todo Slice
const todoSlice = createSlice({
  name: ''todo'', // Action 类型前缀："todo/xxx"
  initialState,
  reducers: {
    // 添加待办：直接修改 state（immer 自动处理不可变）
    addTodo: (state, action) => {
      state.todos.push(action.payload); // 看似“可变”，实际生成新数组
    },
    // 删除待办
    deleteTodo: (state, action) => {
      state.todos = state.todos.filter(todo => todo.id !== action.payload.id);
    },
    // 修改待办状态
    toggleTodo: (state, action) => {
      const todo = state.todos.find(todo => todo.id === action.payload.id);
      if (todo) {
        todo.completed = !todo.completed; // 直接修改对象属性
      }
    }
  }
});

// 自动生成的 Action 创建函数（无需手动定义）
export const { addTodo, deleteTodo, toggleTodo } = todoSlice.actions;

// 导出 Todo Reducer
export default todoSlice.reducer;
```

# 4. configureStore：简化 Store 创建
`configureStore` 是 RTK 替代原生 `createStore` 的 API，内置以下功能：
- 自动组合 Reducer（支持对象形式传入）；
- 内置 `redux-thunk` 中间件（支持异步 Action）；
- 集成 Redux DevTools（无需手动配置）；
- 自动处理中间件顺序和默认配置。

## 4.1 示例：创建根 Store
```javascript
import { configureStore } from ''@reduxjs/toolkit'';
import todoReducer from ''./features/todo/todoSlice'';
import userReducer from ''./features/user/userSlice'';

// 配置 Store
const store = configureStore({
  reducer: {
    // 键名对应状态树的属性，值为对应 Slice 的 Reducer
    todos: todoReducer,
    user: userReducer
  }
  // 可选：自定义中间件、禁用 DevTools 等
  // middleware: (getDefaultMiddleware) => getDefaultMiddleware().concat(logger),
});

export default store;
```

# 5. 核心简化点对比（原生 Redux vs Redux Toolkit）
| 功能                | 原生 Redux                          | Redux Toolkit                      |
|---------------------|-------------------------------------|------------------------------------|
| Action 类型定义      | 手动定义常量（如 ADD_TODO）         | 自动生成（基于 slice.name + 函数名）|
| Action 创建函数      | 手动编写                            | 自动生成（slice.actions）          |
| 不可变状态处理       | 手动扩展运算符/Object.assign        | 内置 immer，支持“可变写法”         |
| Store 配置          | 手动组合 Reducer、添加中间件        | configureStore 一键配置            |
| 代码量              | 冗余（每个 Action/Reducer 需单独写）| 高度封装（一个 slice 搞定模块逻辑）|
', 'a3109983-f66b-42c0-afb5-8d07e97cbc4e', 'true', '2025-12-22 03:11:55.580844+00', '2025-12-23 08:29:46.26142+00'), ('fd26fd36-2e29-4398-bf9c-b45d5a52239b', '组件的复用', '在 React 开发中，多个组件往往会出现相同的业务逻辑（如数据请求、表单验证、权限控制）。为了避免代码冗余，需要通过**组件复用**技术抽离公共逻辑。React 中主流的复用方案有三种：**高阶组件（HOC）**、**Render Props**、**自定义 Hooks**。

# 1. 高阶组件（HOC - Higher-Order Component）
## 1.1 核心概念
高阶组件是**参数为组件，返回值为新组件**的函数，本质是一个函数，不是组件。它的作用是抽离公共逻辑，增强组件的功能。
- **语法结构**：
  ```jsx
  function withHOC(WrappedComponent) {
    // 返回一个新的类组件或函数组件
    return function EnhancedComponent(props) {
      // 公共逻辑处理
      const [data, setData] = useState(null);
      useEffect(() => {
        fetch(''/api/data'').then(res => res.json()).then(data => setData(data));
      }, []);
      // 将公共逻辑的结果通过 props 传递给被包装组件
      return <WrappedComponent {...props} data={data} />;
    };
  }

  // 使用：增强目标组件
  const MyComponent = (props) => <div>{props.data?.name}</div>;
  const EnhancedMyComponent = withHOC(MyComponent);
  ```

## 1.2 核心特性
- **不修改原组件**：高阶组件是纯函数，不会改变传入的组件，而是通过包装生成新组件，遵循“开闭原则”。
- **复用逻辑灵活**：可以传递参数，实现更灵活的逻辑定制。
  ```jsx
  // 带参数的高阶组件
  function withFetch(url) {
    return function(WrappedComponent) {
      return function EnhancedComponent(props) {
        const [data, setData] = useState(null);
        useEffect(() => {
          fetch(url).then(res => res.json()).then(data => setData(data));
        }, [url]);
        return <WrappedComponent {...props} data={data} />;
      };
    };
  }

  // 使用：传入不同的 URL
  const UserComponent = withFetch(''/api/users'')(MyComponent);
  ```
- **常见使用场景**：权限控制、数据请求、日志埋点、样式包装。

## 1.3 优缺点
| 优点 | 缺点 |
|------|------|
| 逻辑复用能力强，适用于类组件和函数组件 | 易产生嵌套地狱（多个 HOC 嵌套使用时，组件层级过深） |
| 可以通过参数定制逻辑 | 命名冲突风险（多个 HOC 传递相同名称的 props 时会覆盖） |
| 社区大量库使用 HOC（如 react-redux 的 connect） | 难以调试（组件被包装后，React DevTools 显示的是增强后的组件） |

# 2. Render Props
## 2.1 核心概念
Render Props 是指**组件通过一个名为 render 的 props 接收一个函数，该函数返回组件需要渲染的内容**。核心思想是将组件的渲染逻辑交给父组件控制，从而实现逻辑复用。
- **语法结构**：
  ```jsx
  // 封装公共逻辑的组件
  class FetchData extends React.Component {
    state = { data: null };

    componentDidMount() {
      fetch(''/api/data'').then(res => res.json()).then(data => this.setState({ data }));
    }

    render() {
      // 调用 render props 函数，传递公共逻辑的结果
      return this.props.render(this.state.data);
    }
  }

  // 使用：父组件控制渲染逻辑
  function App() {
    return (
      <FetchData 
        render={(data) => (
          data ? <div>{data.name}</div> : <div>Loading...</div>
        )} 
      />
    );
  }
  ```
- **注意**：Render Props 不一定叫 `render`，也可以是其他名称的 props，只要是函数即可（如 `children`）。
  ```jsx
  // 使用 children 作为 render props
  <FetchData>
    {(data) => (data ? <div>{data.name}</div> : <div>Loading...</div>)}
  </FetchData>
  ```

## 2.2 核心特性
- **逻辑与视图分离**：公共逻辑封装在组件内部，渲染逻辑由父组件决定，灵活性高。
- **避免嵌套地狱**：相比 HOC，Render Props 的组件层级更扁平，调试更友好。
- **常见使用场景**：鼠标位置监听、数据缓存、表单状态管理。

## 2.3 优缺点
| 优点 | 缺点 |
|------|------|
| 灵活性高，父组件完全控制渲染内容 | 写法相对繁琐，需要额外定义渲染函数 |
| 组件层级扁平，调试方便 | 容易出现闭包陷阱（渲染函数中使用的变量可能不是最新值） |
| 无命名冲突问题（props 由父组件传递） | 不适用于复杂逻辑的复用（多个 Render Props 嵌套时代码可读性下降） |

# 3. 自定义 Hooks
## 3.1 核心概念
自定义 Hooks 是**基于 React 内置 Hooks 封装的函数，用于抽离和复用组件的业务逻辑**，是 React 16.8 推出 Hooks 之后的推荐复用方案。自定义 Hooks 以 `use` 开头，遵循 Hooks 的使用规则。
- **语法结构**：
  ```jsx
  // 封装公共逻辑的自定义 Hook
  function useFetch(url) {
    const [data, setData] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
      const fetchData = async () => {
        try {
          setLoading(true);
          const res = await fetch(url);
          const result = await res.json();
          setData(result);
        } catch (err) {
          setError(err);
        } finally {
          setLoading(false);
        }
      };
      fetchData();
    }, [url]);

    // 返回组件需要的状态和方法
    return { data, loading, error };
  }

  // 使用：在函数组件中调用自定义 Hook
  function UserComponent() {
    const { data, loading, error } = useFetch(''/api/users'');

    if (loading) return <div>Loading...</div>;
    if (error) return <div>Error: {error.message}</div>;
    return <div>{data?.name}</div>;
  }
  ```

## 3.2 核心特性
- **只适用于函数组件**：基于 React 内置 Hooks，只能在函数组件或其他自定义 Hooks 中调用。
- **逻辑复用粒度更细**：可以将复杂逻辑拆分为多个小的自定义 Hooks，组合使用。
- **遵循 Hooks 规则**：
  1. 只能在函数组件的顶层调用 Hooks，不能在条件、循环、嵌套函数中调用。
  2. 只能在函数组件或自定义 Hooks 中调用 Hooks，不能在普通 JavaScript 函数中调用。
- **常见使用场景**：数据请求、表单处理、状态管理、事件监听。

## 3.3 优缺点
| 优点 | 缺点 |
|------|------|
| 逻辑复用粒度细，代码简洁易维护 | 只支持函数组件，无法在类组件中使用 |
| 无嵌套地狱，组件层级清晰 | 受 Hooks 规则限制，使用不当容易出错 |
| 调试友好，React DevTools 可显示 Hook 状态 | 需要理解 Hooks 的工作原理，学习成本较高 |
| 社区生态丰富，大量新库基于自定义 Hooks |  |

# 4. 三种复用方案对比与选型建议
| 方案 | 适用场景 | 推荐指数 |
|------|----------|----------|
| 高阶组件（HOC） | 类组件项目、需要兼容老库、简单逻辑复用 | ★★★☆☆ |
| Render Props | 函数组件/类组件通用、需要灵活控制渲染逻辑 | ★★★★☆ |
| 自定义 Hooks | 函数组件项目、复杂逻辑复用、细粒度逻辑拆分 | ★★★★★ |

**选型建议**：
1. 新项目优先使用 **自定义 Hooks**，代码简洁、逻辑清晰，是 React 官方推荐方案。
2. 若需要兼容类组件，可使用 **Render Props**，避免 HOC 的嵌套问题。
3. 老项目维护或使用依赖 HOC 的库时，可继续使用 **HOC**，但建议逐步迁移到自定义 Hooks。
', '16d6f496-f7f3-422b-baf9-c5f027a71aaa', 'true', '2025-12-19 10:06:06.985007+00', '2025-12-19 10:06:06.985007+00'), ('fd654025-a806-4586-86bf-ae08ce95a3a6', 'JSX基本语法', '# 1. 什么是 JSX
JSX 的全称是 **JavaScript XML**，是 React 提供的一种语法糖，允许开发者在 JavaScript 代码中直接编写类 HTML 的结构。它既不是字符串，也不是 HTML，最终会被编译为 `React.createElement` 函数调用，生成对应的 React 元素（虚拟 DOM 节点）。

使用 JSX 可以让 UI 结构的描述更直观、简洁，相比纯 JavaScript 代码创建元素，可读性大幅提升。

**简单示例**：
```jsx
// JSX 写法
const element = <h1>Hello, React!</h1>;

// 等价的 JavaScript 写法（不使用 JSX）
const element = React.createElement(''h1'', null, ''Hello, React!'');
```

# 2. 核心语法规则
## （1）表达式嵌入
JSX 中可以通过 `{}` 嵌入任意有效的 JavaScript 表达式，表达式的结果会被渲染到页面中。

**支持的表达式类型**：
- 变量、常量
- 算术运算
- 函数调用
- 三元运算符
- 对象属性访问

**示例代码**：
```jsx
import React from ''react'';

function App() {
  // 定义变量
  const name = ''小学生'';
  // 定义算术表达式
  const num1 = 10;
  const num2 = 20;
  // 定义函数
  const getGreeting = () => {
    return `欢迎学习 React！`;
  };

  return (
    <div>
      <h1>你好，{name}！</h1>
      <p>10 + 20 = {num1 + num2}</p>
      <p>{getGreeting()}</p>
      <p>{name === ''小学生'' ? ''适合儿童学习'' : ''适合成人学习''}</p>
    </div>
  );
}

export default App;
```

**注意事项**：
- `{}` 中只能写**表达式**，不能写**语句**（如 `if`、`for` 循环）。如果需要条件判断，可使用三元运算符或在外部定义函数。
- 表达式的值为 `null`、`undefined`、`false` 时，不会在页面渲染任何内容。

## （2）注释写法
JSX 中的注释需要写在 `{}` 内，且遵循 JavaScript 注释规范，有两种常用写法：
- 单行注释：`// 注释内容`
- 多行注释：`/* 多行注释内容 */`

**示例代码**：
```jsx
function App() {
  return (
    <div>
      {/* 这是多行注释
          适用于大段说明 */}
      <h1>Hello JSX</h1>
      {/* 单行注释也可以这样写 */}
      <p>{/* 注释不会显示在页面上 */} 这是一段文本</p>
    </div>
  );
}
```

**注意事项**：
- 注释不能写在 JSX 标签的外面（除非是普通 JavaScript 注释）。
- 注释内容不会被编译到最终的 DOM 结构中。

## （3）属性定义
JSX 标签的属性写法与 HTML 类似，但有几个关键区别，核心规则如下：
1. **属性名使用驼峰命名法**：由于 JSX 最终会被编译为 JavaScript，而 JavaScript 中不允许使用 `-` 连接符，因此属性名需要改为驼峰式。
   例如：`class` → `className`，`tabindex` → `tabIndex`。
2. **属性值写法**
    - 字符串值：使用双引号 `"` 包裹，与 HTML 一致。
    - JavaScript 表达式值：使用 `{}` 包裹，不能加引号。
3. **布尔属性**：如果属性值为 `true`，可以只写属性名；如果为 `false`，可以省略该属性。

**示例代码**：
```jsx
function App() {
  const titleText = "JSX 属性示例";
  return (
    <div>
      {/* 字符串属性值 */}
      <h2 title="这是标题提示">字符串属性</h2>
      {/* 表达式属性值 */}
      <h3 title={titleText}>表达式属性</h3>
      {/* 布尔属性：disabled 为 true */}
      <button disabled>不可点击按钮</button>
      {/* 布尔属性：disabled 为 false，省略属性 */}
      <button>可点击按钮</button>
    </div>
  );
}
```

## （4）样式设置
JSX 中设置样式有两种常用方式：**行内样式**和**类名样式**。

### 方式1：行内样式（推荐用于简单样式）
- 行内样式需要通过 `style` 属性设置，属性值是一个 **JavaScript 对象**。
- 样式属性名使用驼峰命名法（如 `background-color` → `backgroundColor`）。
- 样式值如果是数值类型（如 `width`、`height`），可以省略单位（默认单位是 `px`）；如果是其他单位（如 `rem`），需要写为字符串。

**示例代码**：
```jsx
function App() {
  // 定义样式对象
  const textStyle = {
    color: "red",
    fontSize: "20px", // 字体大小，带单位
    backgroundColor: "#f5f5f5", // 背景色
    padding: 10 // 内边距，省略单位，默认 px
  };
  return (
    <div>
      <p style={textStyle}>行内样式示例</p>
      {/* 直接在标签内写样式对象 */}
      <p style={{ color: "blue", fontSize: "16px" }}>直接设置行内样式</p>
    </div>
  );
}
```

### 方式2：类名样式（推荐用于复杂样式）
- 与 HTML 类似，通过 `className` 属性指定样式类名。
- 样式定义在 `.css` 文件中，然后在组件中引入该 CSS 文件。

**示例代码**：
```css
/* App.css */
.text-class {
  color: green;
  font-size: 18px;
  font-weight: bold;
}
```

```jsx
// App.jsx
import React from ''react'';
import ''./App.css''; // 引入样式文件

function App() {
  return (
    <p className="text-class">类名样式示例</p>
  );
}
```

# 3. 其他重要规则
1. **JSX 必须有且仅有一个根节点**：如果需要渲染多个元素，必须用一个父元素包裹（如 `div`、`Fragment`）。
   ```jsx
   // 错误写法：多个根节点
   function App() {
     return (
       <h1>标题</h1>
       <p>文本</p>
     );
   }

   // 正确写法：用 div 包裹
   function App() {
     return (
       <div>
         <h1>标题</h1>
         <p>文本</p>
       </div>
     );
   }

   // 正确写法：用 Fragment 包裹（无额外 DOM 节点）
   function App() {
     return (
       <React.Fragment>
         <h1>标题</h1>
         <p>文本</p>
       </React.Fragment>
     );
     // 简写形式：<>...</>
     // return (
     //   <>
     //     <h1>标题</h1>
     //     <p>文本</p>
     //   </>
     // );
   }
   ```
2. **标签必须闭合**：JSX 是严格的 XML 语法，所有标签都必须闭合，包括自闭合标签（如 `<img>` → `<img />`、`<input>` → `<input />`）。', '22e948d7-98f2-4c47-8ae2-4abb0990f9f7', 'true', '2025-12-19 07:29:14.249044+00', '2025-12-19 09:20:04.662094+00'), ('fe01f2e0-a917-4111-a1b7-d2192c066b0e', 'JSX 本质', '很多开发者会误以为 JSX 是 React 独有的模板语言，但实际上 **JSX 只是 `React.createElement` 函数的语法糖**。所有的 JSX 代码，最终都会被 Babel 等编译工具转换为 `React.createElement` 函数的调用，进而生成 React 元素（虚拟 DOM 节点）。

# 1. JSX 编译过程
我们可以通过一个简单的例子，直观地看 JSX 是如何被编译的。

**步骤1：编写 JSX 代码**
```jsx
const element = <h1 className="title">Hello JSX</h1>;
```

**步骤2：Babel 编译为 `React.createElement` 调用**
上述 JSX 代码会被编译为以下 JavaScript 代码：
```javascript
const element = React.createElement(
  ''h1'', // 标签名/组件名
  { className: ''title'' }, // 属性对象
  ''Hello JSX'' // 子元素/文本内容
);
```

**步骤3：执行函数生成 React 元素**
`React.createElement` 函数执行后，会返回一个**React 元素对象**（虚拟 DOM 节点），结构如下：
```javascript
const element = {
  type: ''h1'',
  props: {
    className: ''title'',
    children: ''Hello JSX''
  },
  // 其他内部属性（如 key、ref 等）
};
```
这个对象描述了 DOM 节点的类型、属性和子元素，React 会根据这个对象构建真实的 DOM 结构。

#  2. `React.createElement` 函数参数详解
`React.createElement` 函数的作用是创建并返回一个 React 元素对象，其函数签名如下：
```javascript
React.createElement(type, [props], [...children]);
```

参数说明：
1. **`type`**（必选）
    - 表示要创建的元素类型，可以是：
        - 字符串：代表 HTML 原生标签（如 `''div''`、`''h1''`、`''p''`）。
        - React 组件：自定义的函数组件或类组件（如 `Button`、`App`）。
2. **`props`**（可选）
    - 一个对象，包含元素的所有属性（如 `className`、`onClick`、`style` 等）。
    - 如果没有属性，该参数可以传 `null` 或省略。
3. **`children`**（可选，可变参数）
    - 表示元素的子节点，可以是：
        - 字符串：文本内容。
        - React 元素：嵌套的 JSX 元素。
        - 表达式：通过 `{}` 嵌入的 JavaScript 表达式结果。
    - 多个子节点可以依次传入。

# 3. 复杂 JSX 编译示例
对于嵌套的复杂 JSX 结构，编译后的 `React.createElement` 调用也会相应嵌套。

**复杂 JSX 代码**：
```jsx
const element = (
  <div className="container">
    <h1>Hello React</h1>
    <p>JSX 本质是函数调用</p>
  </div>
);
```

**编译后的 JavaScript 代码**：
```javascript
const element = React.createElement(
  ''div'',
  { className: ''container'' },
  React.createElement(''h1'', null, ''Hello React''),
  React.createElement(''p'', null, ''JSX 本质是函数调用'')
);
```

**生成的 React 元素对象**：
```javascript
const element = {
  type: ''div'',
  props: {
    className: ''container'',
    children: [
      {
        type: ''h1'',
        props: { children: ''Hello React'' }
      },
      {
        type: ''p'',
        props: { children: ''JSX 本质是函数调用'' }
      }
    ]
  }
};
```

# 4. 为什么需要 JSX
既然 JSX 最终会被编译为 `React.createElement` 调用，那我们为什么不直接写 `React.createElement`，而是要用 JSX 呢？

核心原因有两点：
1. **提高可读性**：对于复杂的 UI 结构，JSX 的类 HTML 写法比嵌套的函数调用更直观，更容易理解和维护。
2. **降低学习成本**：前端开发者对 HTML 语法非常熟悉，使用 JSX 可以快速上手 React，无需记忆复杂的函数调用参数顺序。

# 5. 不使用 JSX 的 React 开发
虽然 JSX 很方便，但 React 并不强制要求使用它。如果项目中没有配置 Babel 编译 JSX，或者开发者不想使用 JSX，完全可以通过直接调用 `React.createElement` 来开发 React 应用。

**示例：不使用 JSX 开发组件**
```javascript
import React from ''react'';
import ReactDOM from ''react-dom/client'';

// 不使用 JSX 的函数组件
function App() {
  return React.createElement(
    ''div'',
    { className: ''app'' },
    React.createElement(''h1'', null, ''不使用 JSX 的 React 应用''),
    React.createElement(''p'', null, ''直接调用 React.createElement'')
  );
}

// 渲染组件
const root = ReactDOM.createRoot(document.getElementById(''root''));
root.render(React.createElement(App));
```

这种写法虽然可行，但对于复杂组件来说，代码会变得非常冗长且难以维护，因此**推荐使用 JSX 开发 React 应用**。
', '22e948d7-98f2-4c47-8ae2-4abb0990f9f7', 'true', '2025-12-19 07:39:01.729432+00', '2025-12-23 03:18:33.282112+00');