$(document).ready(function(){
	$(".resultsbox").hide();
});

function showAssignments(){
	$.ajax({
	  url: 'http://localhost:4567/assignments?set=19&faculty=31742',
	  success: addAssignments,
	});
	
}

function addAssignments(data){
	$("#box_23").show();
	$(data).each(function(ind, elt){
		var name = elt[0].person.first_name + " " + elt[0].person.last_name;
		var studentDiv=document.createElement("div");
		$(studentDiv).text(name);
		$("#results_23").append(studentDiv);
	});
	
}