<cfoutput>
  <section class="center-w-flex mt-8">

    <div class="lead-container">
     <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
       <path stroke-linecap="round" stroke-linejoin="round" d="M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12Z" />
       </svg>
           <h1 class="lead-title">My Favorites</h1>
     </div>

     <cfif !arrayLen(rc.favorites)>

      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="icon-title">
        <path stroke-linecap="round" stroke-linejoin="round" d="M15.182 16.318A4.486 4.486 0 0 0 12.016 15a4.486 4.486 0 0 0-3.198 1.318M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0ZM9.75 9.75c0 .414-.168.75-.375.75S9 10.164 9 9.75 9.168 9 9.375 9s.375.336.375.75Zm-.375 0h.008v.015h-.008V9.75Zm5.625 0c0 .414-.168.75-.375.75s-.375-.336-.375-.75.168-.75.375-.75.375.336.375.75Zm-.375 0h.008v.015h-.008V9.75Z" />
      </svg>
      
         <div class="instruction instruction-enhanced mt-4">
          "You don't have any favorites yet! Browse our inventory and tap the heart icon to start building your favorites list. Come back here anytime to view all your saved items in one place!"
         </div>
     <cfelse>
         <div class="instruction instruction-enhanced">
           Keep track of your favorite items. Tap the heart icon to add or remove from your personalized list.
       </div>
     </cfif>
 </section>
  
    <div class="container">

          <div class="hits">
            <div >
              <div class="ais-Hits">
                <ol class="ais-Hits-list">

                <cfloop array="#rc.favorites#" item="favorite">
              
                  <cfset plural = favorite.qty gt 1 ? 's' : '' >

                    <li class="ais-Hits-item">
                      <article class="hit" itemscope itemtype="http://schema.org/Product" >
                        <header>
                        <a href="javascript:void(0)" x-on:click.prevent="$dispatch('show-item', { itemno: #favorite.itemno# })">
                          <svg xmlns="http://www.w3.org/2000/svg" class="hit-svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
                          </svg>
                          <div class="hit-image">
                            <img itemprop="image" src="#favorite.imgbase##favorite.imgMain#" alt="#favorite.headline#" />
                          </div>
                        </a> 
                        <link itemprop="url" href="#favorite.imgbase##favorite.imgMain#" />
                        </header>
                
                        <main>
                        <div class="hit-detail">
                          <p itemprop="category" class="category">#favorite.category#</p> 
                          <h1 itemprop="name"  class="headline">#favorite.headline#</h1> 
                          <p itemprop="description" class="description">#favorite.description#</p> 
                        </div>
                        </main>
                      
                        <footer>
                        <p itemprop="manufacturer" class="hit-mfr">Make: <span>#favorite.mfr#</span></p>
                        <p itemprop="model" class="hit-model">Model: <span>#favorite.model#</span></p>
                        <p itemprop="offers" itemscope itemtype="http://schema.org/Offer">
                          <span class="hit-qty">#favorite.qty# unit#plural# @</span> <span itemprop="price" content="#favorite.price#" class="hit-price">#favorite.price#</span>
                        </p>
                        <div class="hit-footer">
                          <p><span class="location">#favorite.location#</span></p>
                          <p><span class="bullet">Item</span> <a href="#favorite.encItemURI#"><span itemprop="productID" class="itemno">#favorite.itemno#</span></a></p>
                        </div>
                        <div class="item">	
                          <div class="userprefs">
                            <div>
                              <a href="javascript:void(0)" x-on:click.prevent="$store.favorites.IsloggedIn ? $store.favorites.toggle(#favorite.itemno#) : $dispatch('show-login', { title: 'You must login to continue' })">
                                <svg xmlns="http://www.w3.org/2000/svg"  
                                :class="{ 'favorite': $store.favorites.isFavorite(#favorite.itemno#) }" 
                                :fill="$store.favorites.isFavorite(#favorite.itemno#) ? '##fa0114' : 'none'"
                                viewBox="0 0 24 24" stroke="currentColor"
                                ><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
                                </svg>Favorite
                              </a>
                            </div>
                            <div>
                              <a href="javascript:void(0)" x-on:click.prevent="$clipboard('#favorite.encItemURI#');$tooltip('Copied to clipboard!')"><svg fill=none xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" stroke="currentColor">
                              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.368 2.684 3 3 0 00-5.368-2.684z" />
                              </svg>Share</a>
                            </div>
                          </div>
                          </div>
                        </footer>
                      </article>
                    </li>

                </cfloop>
                </ol>
              </div>
            </div>
          </div>
     </div>
  
 #view('common/fragment/itemPreview')#
 

</cfoutput>
  
  
      
      
  