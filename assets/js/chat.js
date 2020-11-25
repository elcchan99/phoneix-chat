let Chat = {
  init(socket) {
    if (!window.location.pathname.startsWith("/chat")) {
      return;
    }
    let path = window.location.pathname.split("/");
    let room = path[path.length - 1];
    let channel = socket.channel(`chat:${room}`, {});
    channel.join().receive("ok", (resp) => {
      console.log(`Joined ${room} successfully`, resp);
    });

    this.listenForChats(channel);
  },

  getChatFormData() {
    return {
      name: document.getElementById("user-name").value,
      message: document.getElementById("user-message").value,
    };
  },

  cleanChatForm({ name: name }) {
    document.getElementById("user-name").value = name;
    document.getElementById("user-message").value = "";
  },

  addChatMessage({ name: name, message: message }) {
    let chatBox = document.querySelector("#chat-box");
    let msgBlock = document.createElement("p");

    msgBlock.insertAdjacentHTML("beforeend", `<b>${name}</b>: ${message}`);
    chatBox.appendChild(msgBlock);
  },

  refreshOnlineStatus(onlineStatusObj) {
    console.log(onlineStatusObj);
    let onlineStatus = document.querySelector(".online-status .content");
    onlineStatus.innerHTML = "";

    let ul = document.createElement("ul");
    Object.entries(onlineStatusObj).forEach(([name, status], _) => {
      console.log("name", name);
      console.log("status", status);
      let li = document.createElement("li");
      li.innerHTML = `<div class="icon icon-${status}line"></div><span>${name}<span>`;
      ul.appendChild(li);
    });
    onlineStatus.append(ul);
  },

  listenForChats(channel) {
    let that = this;
    function submitForm() {
      let chatData = that.getChatFormData();
      channel.push("shout", chatData);
      that.cleanChatForm(chatData);
    }

    document
      .getElementById("chat-form")
      .addEventListener("submit", function (e) {
        e.preventDefault();
        console.log(`form submitted: ${e}`, e);
        submitForm();
      });

    channel.on("shout", this.addChatMessage);
    channel.on("online-status-update", this.refreshOnlineStatus);
  },
};
export default Chat;
