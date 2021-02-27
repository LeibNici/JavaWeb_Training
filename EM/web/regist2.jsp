<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>欢迎注册EasyMall</title>
    <meta http-equiv="Content-type" content="text/html; charset=UTF-8" />
    <link rel="stylesheet" href="/EM01/css/regist.css"/>
    <script type="application/javascript">
        //表单提交校验
        function checkForm(){
            var canSub = true;
            canSub = checkNull("username","用户名不能为空") && canSub;
            canSub = checkNull("nickname","昵称不能为空") && canSub;
            canSub = checkNull("email","邮箱不能为空") && canSub;
            canSub = checkNull("valistr","验证码不能为空") && canSub;
            canSub = checkPsw() && canSub;
            canSub = checkEmail() && canSub;
            return canSub;
        }

        //邮箱校验
        function checkEmail(){
            setMsg("email","")
            var email = document.getElementsByName("email")[0].value;
            if(email.trim()==""){
                setMsg("email","邮箱不能为空！")
                return false;
            }
            if(!/^\w+@\w+(\.\w+)+$/.test(email)){
                setMsg("email","邮箱格式不正确！")
                return false;
            }
            return true;
        }

        //密码校验
        function checkPsw(){
            setMsg("password","")
            setMsg("password2","")
            var flag = true;
            var psw1 = document.getElementsByName("password")[0].value
            var psw2 = document.getElementsByName("password2")[0].value
            if(psw1.trim()==""){
                setMsg("password","密码不能为空")
                flag = false;
            }
            if(psw2.trim()==""){
                setMsg("password2","确认密码不能为空")
                flag = false;
            }
            if(flag && psw1.trim()!=psw2.trim()){
                setMsg("password2","两次密码不一致！");
                flag = false;
            }
            return flag;
        }

        //校验用户名
        function checkUsername(){
            setMsg("username","");
            //--检查用户名是否为空
            var flag = checkNull("username","用户名不能为空")
            //--AJAX检查用户名是否已经存在
            if(flag){
                var username = document.getElementsByName("username")[0].value.trim();
                //--创建XmlHttpRequest对象
                var xmlHttp = new XMLHttpRequest();
                //--设置回调函数
                xmlHttp.onreadystatechange=function(){
                    if(xmlHttp.readyState == 4){
                        if(xmlHttp.status==200 || xmlHttp.status==304){
                            var rdata = xmlHttp.responseText;
                            setMsg("username",rdata)
                        }else{
                            setMsg("username","校验失败！")
                        }
                    }
                }
                //--发送请求
                xmlHttp.open("POST","<%=request.getContextPath()%>/AjaxHasUsernameServlet",true)
                xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded")
                xmlHttp.send("username="+username);
            }
        }

        //非空校验
        function checkNull(pname,pmsg){
            setMsg(pname,"")
            var v = document.getElementsByName(pname)[0].value;
            if(v.trim() == ""){
                setMsg(pname,pmsg);
                return false;
            }
            return true;
        }

        //设置提示信息
        function setMsg(pname,pmsg){
            document.getElementById(pname+"_msg").innerHTML="<font color='red'>"+pmsg+"</font>";
        }

        //点击更换验证码
        function changeImg(imgObj){
            imgObj.src = "<%=request.getContextPath()%>/ValiImgServlet?time="+new Date().getTime();
        }
    </script>
</head>
<body>
<h1>欢迎注册EasyMall</h1>
<form action="<%=request.getContextPath()%>/RegistServlet" method="POST" onsubmit="return checkForm()">
    <table>
        <tr>
            <td colspan="2">
                <span>
                <%=request.getAttribute("msg") == null ? "" : request.getAttribute("msg")%>
                </span>
            </td>
        </tr>
        <tr>
            <td class="tds">用户名：</td>
            <td>
                <input type="text" name="username" onblur="checkUsername()">
                <span id="username_msg"></span>
            </td>
        </tr>
        <tr>
            <td class="tds">密码：</td>
            <td>
                <input type="password" name="password" onblur="checkNull('password','密码不能为空！')">
                <span id="password_msg"></span>
            </td>
        </tr>
        <tr>
            <td class="tds">确认密码：</td>
            <td>
                <input type="password" name="password2" onblur="checkPsw()">
                <span id="password2_msg"></span>
            </td>
        </tr>
        <tr>
            <td class="tds">昵称：</td>
            <td>
                <input type="text" name="nickname" onblur="checkNull('nickname','昵称不能为空！')">
                <span id="nickname_msg"></span>
            </td>
        </tr>
        <tr>
            <td class="tds">邮箱：</td>
            <td>
                <input type="text" name="email" onblur="checkEmail()">
                <span id="email_msg"></span>
            </td>
        </tr>
        <tr>
            <td class="tds">验证码：</td>
            <td>
                <input type="text" name="valistr" onblur="checkNull('valistr','验证码不能为空！')">
                <img id="yzm_img" src="<%=request.getContextPath()%>/ValiImgServlet" style="cursor: pointer" onclick="changeImg(this)"/>
                <span id="valistr_msg"></span>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <input type="submit" value="注册用户"/>
            </td>
        </tr>
    </table>
</form>
</body>
</html>
