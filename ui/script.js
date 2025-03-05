window.addEventListener("message", function(event) {
    if (event.data.action === "open") {
        document.getElementById("tablet-frame").style.display = "flex";
        document.getElementById("infohub").style.display = "block";
    } else if (event.data.action === "close") {
        document.getElementById("tablet-frame").style.display = "none";
        document.getElementById("infohub").style.display = "none";
    }
});

document.getElementById("close-button").addEventListener("click", function() {
    fetch("https://ne-infohub/closeUI", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({})
    }).catch(error => {
        console.error("Error closing NUI:", error);
    });
});
