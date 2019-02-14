<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" 
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

<style>
#modDiv {
	width: 300px;
	height: 100px;
	background-color: gray;
	position: absolute;
	top: 50%;
	left: 50%;
	margin-top: -50px;
	margin-left: -150px;
	padding: 10px;
	z-index: 1000;
}

/* .pagination {
  width: 100%;
}

.pagination li{
  list-style: none;
  float: left; 
  padding: 3px; 
  border: 1px solid blue;
  margin:3px;  
}

.pagination li a{
  margin: 3px;
  text-decoration: none;  
} */

</style>
</head>

<body>



	<h2>Ajax Test Page</h2>
	
    <div>
		<div>
			<div>REPLYER <input type="text" name="replyer" id="newReplyWriter" /></div>
		</div>
		
		<div>REPLY TEXT<input type="text" name="replytext" id="newReplyText" /></div>
		
		<button id="replyAddBtn">ADD REPLY</button>	
    </div>
	 
	 <div id='modDiv' style="display:none;">
	 <div>
	 	<div class='modal-title'></div>
	 	<div><input type="text" id='replytext' /></div>
	 	
	 	<div>
	 		<button type="button" id="replyModBtn">UPDATE</button>
	 		<button type="button" id="replyDelBtn">DELETE</button>
	 		<button type="button" id="closeBtn">CLOSE</button>
	 	</div>
	 
	 
	 </div>	
	</div>	
	
	

	<ul id="replies">
	</ul>
	
	


	<!-- jQuery 2.1.4 -->
	<script src="/resources/plugins/jQuery/jQuery-2.1.4.min.js"></script>

	<script>
		var bno = 4;
		function getAllList() {
			
			$.getJSON("/replies/all/" + bno,function(data) {
			//console.log(data.length);
			var str = "";
			$(data).each(function() {
				str += "<li data-rno='"+this.rno+"' class='replyLi'>"
					+ this.rno
					+ ":"
					+ this.replytext
					+ "<button>MOD</button></li>";
				});

			$("#replies").html(str);
		});
	}
		
		$("#replyAddBtn").on("click", function() {

			var replyer = $("#newReplyWriter").val();
			var replytext = $("#newReplyText").val();

			$.ajax({
				type : 'post',
				url : '/replies',
				headers : {
					"Content-Type" : "application/json",
					"X-HTTP-Method-Override" : "POST"
				},
				dataType : 'text',
				data : JSON.stringify({
					bno : bno,
					replyer : replyer,
					replytext : replytext
				}),
				success : function(result) {

					if (result == 'SUCCESS') {

						alert("등록 되었습니다.");
						getAllList();
					}
				}
			});
		});
		
		$("#replies").on("click", ".replyLi button", function() {

			var reply = $(this).parent();

			var rno = reply.attr("data-rno");
			
			var replytext = reply.text();
			
			$(".modal-title").html(rno);
			$("#replytext").val(replytext);
			$("#modDiv").show("slow");
		});
		
		$("#replyDelBtn").on("click", function() {

			var rno = $(".modal-title").html();
			var replytext = $("#replytext").val();

			$.ajax({
				type : 'delete',
				url : '/replies/' + rno,
				headers : {
					"Content-Type" : "application/json",
					"X-HTTP-Method-Override" : "DELETE"
				},
				dataType : 'text',
				success : function(result) {
					console.log("result: " + result);
					if (result == 'SUCCESS') {
						alert("삭제 되었습니다.");
						$("#modDiv").hide("slow");
						getAllList();
					}
				}
			});
		});
		
		$("#replyModBtn").on("click",function(){
			  
			  var rno = $(".modal-title").html();
			  var replytext = $("#replytext").val();
			  
			  $.ajax({
					type:'put',
					url:'/replies/'+rno,
					headers: { 
					      "Content-Type": "application/json",
					      "X-HTTP-Method-Override": "PUT" },
					data:JSON.stringify({replytext:replytext}), 
					dataType:'text', 
					success:function(result){
						console.log("result: " + result);
						if(result == 'SUCCESS'){
							alert("수정 되었습니다.");
							 $("#modDiv").hide("slow");
							//getAllList();
							 getPageList(replyPage);
						}
				}});
		});		
		
		
		
		
		
		
		

		
	</script>

</body>
</html>

