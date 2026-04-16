import consumer from "./consumer"

document.addEventListener("turbo:load", function() {
  const messagesContainer = document.getElementById("messages");
  
  if (messagesContainer && messagesContainer.dataset.conversationId) {
    const conversationId = messagesContainer.dataset.conversationId;
    
    // Subscribe to the conversation channel
    window.chatChannel = consumer.subscriptions.create(
      { channel: "ConversationChannel", id: conversationId },
      {
        connected() {
          console.log("Connected to conversation " + conversationId);
        },

        disconnected() {
          console.log("Disconnected from conversation " + conversationId);
        },

        received(data) {
          if (data.remove) {
            // Remove message
            const messageEl = document.querySelector(`[data-message-id="${data.remove}"]`);
            if (messageEl) messageEl.remove();
          } else {
            // Add new message
            messagesContainer.insertAdjacentHTML("beforeend", data);
            messagesContainer.scrollTop = messagesContainer.scrollHeight;
            
            // Clear input
            const form = document.getElementById("new_message_form");
            if (form) {
              const input = form.querySelector("input[name='direct_message[content]']");
              if (input) input.value = "";
            }
          }
        }
      }
    );
  }
});
