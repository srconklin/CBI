<style>

.deal-panel {
  border: 1px solid #ccc;
  border-radius: 3px;
  margin-left: auto;
  margin-right: auto;
  max-width: 700px;
  display: flex;
  flex-direction: column;
  padding-bottom: 12px;
  padding-top: 12px;

.deal-container {
  max-width: 72%;
  margin: 12px 24px;
}

.deal-head {
  padding: 9px;
  background-color: #dedede;
  border-top-right-radius : 8px;
  border-top-left-radius: 8px;
  display: flex;
  justify-content: space-between;
  align-items: center;
    }
  
}

.deal-head svg {
  width: 2.0rem;
  height: 2.0rem;
}

.deal-head .time {
  font-size: small;
}

.deal-message {
  background: #f8f8f8;
  border-bottom-right-radius : 8px;
  border-bottom-left-radius: 8px;
  font-size: 14px;
  line-height: 1.4em;
  

  padding: 12px;
  position: relative;
}

/* .deal-message::before, .deal-message::after {
  content: "";
  bottom: 0;
  height: 20px;
  left: -10px;
  position: absolute;
}
.deal-message:before {
  border-color: #dedede;
  border-left-style: solid;
  border-left-width: 20px;
  border-bottom-right-radius: 50%;
  z-index: -1;
}
.deal-message::after {
  background: #ffffff;
  border-bottom-right-radius: 50%;
  width: 10px;
  z-index: 1; 
}
*/
.deal-container.mine  {
 margin-left: auto;
}

.mine .deal-message  {
  /* background: #f8eeee;  #3888ea; */
  /* color: #fff; */
  
}
/* .deal-message.mine::before, .deal-message.mine::after {
  left: auto;
  right: -10px;
}
.deal-message.mine::before {
  border: none;
  border-color: #3888ea;
  border-right-style: solid;
  border-right-width: 20px;
  border-bottom-left-radius: 50%;
}
.deal-message.mine:after {
  border-bottom-left-radius: 50%;
} */



</style>

<div class="deal-panel">
    
  <div class="deal-container mine"> 
     <div class="deal-head"> 
      <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="64px" height="64px" viewBox="0 0 64 64" version="1.1">
        <circle fill="#FFFFFF" cx="32" width="64" height="64" cy="32" r="32"></circle>
        <text x="50%" y="50%" fill="#fa0114" style="color: #fa0114; line-height: 1;font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', 'Ubuntu', 'Fira Sans', 'Droid Sans', 'Helvetica Neue', sans-serif;" alignment-baseline="middle" text-anchor="middle" font-size="30" font-weight="600" dy=".1em" dominant-baseline="middle">SC</text>
      </svg>
      <div class="time">Aug 13 2024 2:50 PM</div>
   </div>
    <div class="deal-message ">
        <span>Lorem ipsum dolor sit, amet consectetur adipisicing elit. Nisi, soluta dolorem. Officia temporibus ipsam consectetur quibusdam in totam recusandae voluptatem. Impedit, sapiente delectus quaerat eius perspiciatis repudiandae facere dicta sed?</span>
     </div>
  </div>

  <div class="deal-container"> 
  <div class="deal-head"> 
    <div class="flex align-center">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="size-6">
        <path fill-rule="evenodd" d="M7.5 6a4.5 4.5 0 1 1 9 0 4.5 4.5 0 0 1-9 0ZM3.751 20.105a8.25 8.25 0 0 1 16.498 0 .75.75 0 0 1-.437.695A18.683 18.683 0 0 1 12 22.5c-2.786 0-5.433-.608-7.812-1.7a.75.75 0 0 1-.437-.695Z" clip-rule="evenodd" />
      </svg>
      <span>CBI Staff</span>
    </div> 
    <div class="time">Aug 14 2024 3:50 PM</div>
  </div>
    <div class="deal-message ">
      <span>Lorem ipsum dolor sit, amet consectetur adipisicing elit. Nisi, soluta dolorem. Officia temporibus ipsam consectetur quibusdam in totam recusandae voluptatem. Impedit, sapiente delectus quaerat eius perspiciatis repudiandae facere dicta sed?</span>
    </div>
  </div>

</div>