// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
// require turbolinks
//= require owl.carousel
//= require_tree .


// $("#big-search-box").bind("keyup", function() {
$(document).on('keyup','#big-search-box', {}, function() {

	var myList = document.getElementsByClassName("col-xs-8");
	for(var i=0; i<myList.length; i++) {
		try {
			myList[i].style.display = "none";
		} catch (err){
				console.log(err.message);
		}
	}
	
  $("#loader").addClass("loader"); // show the spinner
  var form = $("#live-search-form"); // grab the form wrapping the search bar.
  var url = "/parts/live_search?q="; // live_search action.    
  var pcbidd = $(':input[id="pcbid"]').val();
  var formD = 'pcbid=' // grab the data in the form    
  var formData= formD + pcbidd;
  var word = $(':input[id="big-search-box"]').val();
  var final = url + word;
  $.get(final, formData, function(html) { // perform an AJAX get

    $("#loader").removeClass("loader"); // hide the spinner

    $("#ids_array").html(html); // replace the "results" div with the results
	 var ids_string = document.getElementById("ids_array").innerHTML.replace('[',',').replace(']',',').replace(/ /g, '')
	  var myArray = ids_string.split(",");
	  for(var i=0; i<myArray.length; i++) { 
		console.log(" loop for "+i);
		 var dev_id = myArray[i]; 
		 console.log("dev_id: "+dev_id);
			 try {
				document.getElementById("single_line_"+dev_id).style.display = "initial";
			}
			catch(err) {
				console.log(err.message);
			}
		 console.log("single_line_"+dev_id);
	  } 
  });
});

function follow_link() {
	var url = $("#linker_select").val();
	document.location.href=url
}


function imgFunction(file_name) {
	$(".preview")
        .fadeOut(100, function() {
            $(".preview").attr('src', file_name);
            $("#img01").attr('src', file_name.replace("medium","original"));
        })
        .fadeIn(200)
}

$(window).ready(function () {
  
	$(".notice-msg").delay(2000).fadeOut("1000");
	$(".error-msg").delay(2000).fadeOut("1000");
	
	 $(window).scroll(function(){
        if ($(this).scrollTop() > 80) {
            $(".scrollToTop").fadeIn(500)
        } else {
            $(".scrollToTop").fadeOut(500);
        }
    });

    //Click event to scroll to top
    $(".scrollToTop").click(function(){
        $('html, body').animate({scrollTop : 0},200);
        return false;
    });
	
    $(".leftArrow").click(function () { 
	  var leftPos = $('.project-upper-right-down-icons').scrollLeft();
	  $(".project-upper-right-down-icons").animate({scrollLeft: leftPos - 200}, 500);
	});

	$(".rightArrow").click(function () { 
	  var leftPos = $('.project-upper-right-down-icons').scrollLeft();
	  $(".project-upper-right-down-icons").animate({scrollLeft: leftPos + 200}, 500);
	});
	
    $(".leftArrowD").click(function () { 
	  var leftPos = $('.project-upper-left-files').scrollLeft();
	  $(".project-upper-left-files").animate({scrollLeft: leftPos - 200}, 500);
	});

	$(".rightArrowD").click(function () { 
	  var leftPos = $('.project-upper-left-files').scrollLeft();
	  $(".project-upper-left-files").animate({scrollLeft: leftPos + 200}, 500);
	});
	
	$("#owl-demo").owlCarousel({
 
      navigation : true, // Show next and prev buttons
      slideSpeed : 300,
      paginationSpeed : 400,
      singleItem:true 
  });
  
});

/*if (document.addEventListener) {
        document.addEventListener('contextmenu', function(e) {
            alert("Context menu comming soon"); //here you draw your own menu
            e.preventDefault();
        }, false);
    } else {
        document.attachEvent('oncontextmenu', function() {
            alert("Context menu comming soon");
            window.event.returnValue = false;
        });
}*/

