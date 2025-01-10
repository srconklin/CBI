<!--- show search results when we have a search query --->
<div id="algolia">

    <!--- breadcrumb --->
    <div class="breadcrumb">
      <div id="breadcrumb"></div>
    </div>
    
<!--- search results main wrapper   :class="{ 'filtermode': showFilter }" --->
<div class="search-results" 
    x-data="{ showFilter: false, isLargeScreen: window.innerWidth >= 700 }" 
    @resize.window="isLargeScreen = window.innerWidth >= 700; if (!isLargeScreen) showFilter = false"
   >

  <!--- show/hide filters (red button)  --->
  <div id="filterbar" class="filterbar" :class="{'remove-margin' : showFilter}">
    <button class="filter btn btn-primary" :class="{'opened' : showFilter}" type="button"
    <!--- $dispatch('blur-bg', !showFilter); --->
      @click.prevent=" showFilter = !showFilter">
      <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
          d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4" />
      </svg>
      <span x-show="!showFilter">show filters</span>
      <span x-show="showFilter">hide filters</span>
    </button>
  </div>

  <!--- refinements (left panel sidebar)   :class="{ 'hidden': !showFilter }"  --->
  <div id="refinements" x-show="isLargeScreen || showFilter" class="left-panel"  :class="{ 'highlight': showFilter }">
    <div class="dash">
      <!--- <h3 x-show="!showFilter">Filters</h3> --->
      <div id="statsfilter"></div>
      <!---  @click.prevent="$dispatch('blur-bg', false)" --->
      <div id="clear-refinements"></div>
    </div>
    <div class="refinement-container">
      <div id="categories"></div>
      <div id="mfr"></div>
    </div>
  </div>

  <!--- hit results (right panel sidebar)  :class="{ 'hidden': showFilter && !isLargeScreen}" --->
  <div class="search-panel"  >
      <div class="dashboard">
        <div id="stats"></div>
        <div id="sort-by"></div>
      </div>
      <!--- hit cards --->
      <div id="hits" ></div>
      <div id="pagination"></div>
  </div>

</div>


<cfoutput>
 #view('common/fragment/itemPreview')#
 #view('/common/fragment/login')# 
</cfoutput>
