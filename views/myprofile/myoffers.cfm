<div 
    id="myoffers" 
    class="general-page"
    x-cloak
    x-data = "{
        generalError : '',
        deals: JSON.parse('<cfoutput>#encodeForJavaScript( serializeJson( rc.offers ) )#</cfoutput>')
    }"
    @show-dealdetails-error.window="generalError= $event.detail.error"
>
    <!--- You currently have no offers or inquiries. Browse our listings and submit an inquiry or make an offer to start a conversation. Once you do, all of your interactions and responses from our team will appear here for easy tracking and follow-up --->
    <section class="center-w-flex mt-8">

        <div class="lead-container">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
                <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 14.25v-2.625a3.375 3.375 0 0 0-3.375-3.375h-1.5A1.125 1.125 0 0 1 13.5 7.125v-1.5a3.375 3.375 0 0 0-3.375-3.375H8.25m3.75 9v7.5m2.25-6.466a9.016 9.016 0 0 0-3.461-.203c-.536.072-.974.478-1.021 1.017a4.559 4.559 0 0 0-.018.402c0 .464.336.844.775.994l2.95 1.012c.44.15.775.53.775.994 0 .136-.006.27-.018.402-.047.539-.485.945-1.021 1.017a9.077 9.077 0 0 1-3.461-.203M10.5 2.25H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 0 0-9-9Z" />
              </svg>
               <h1 class="lead-title">Offers and Inquiries</h1>
         </div>

        <div class="instruction instruction-enhanced" x-show="deals.length">
            Here are all your active offers and inquiries. You can review each interaction, respond to site admins, and see their replies. Keep track of updates and follow up easily on each item of interest. Click on any conversation to view details or continue the discussion!
        </div>
        <div class="instruction instruction-enhanced" x-show="!deals.length">
            You currently have no offers or inquiries. Browse our listings and submit an inquiry or make an offer to start a conversation. Once you do, all of your interactions and responses from our team will appear here for easy tracking and follow-up 
        </div>

     </section>

    <div class="container">
        <div class="mt-6">

            <div
            class="form-row" 
            style="margin: auto; max-width: fit-content;"
            x-cloak 
            x-show="generalError">
            <p 
                class="message-box error" 
                x-html="generalError">
            </p>
            </div>

            <table  role="table" class="table" x-show="deals.length">
                <thead role="rowgroup">
                <tr role="row">
                    <th role="columnheader">Ref #</th>
                    <th role="columnheader">Date</th>
                    <th role="columnheader">Type</th>
                    <th role="columnheader">Status</th>
                    <th role="columnheader">Item&nbsp;ID</th>
                    <th role="columnheader">Description</th>
                </tr>
                </thead>
                <tbody role="rowgroup">
                <!--- <template x-if="!deals">
                <tr><td role="cell" colspan="5"><i>No Offers or Inquiries yet...</i></td></tr>
                </template>   --->
                <template x-for="deal in deals">
                    <tr role="row" x-on:click.prevent="$dispatch('show-dealdetails', {refnr: deal.refnr})">
                        <td role="cell" x-text="deal.refnr"></td>
                        <td role="cell" x-text="deal.date"></td>
                        <td role="cell" x-text="deal.type"></td>
                        <td role="cell"><span :class="deal.status == 'Pending' ? 'pill pill-red' : 'pill pill-green'" x-text="deal.status"></span></td>
                        <td role="cell" x-text="deal.itemno"></td>
                        <td role="cell" x-text="deal.description"></td>
                    </tr>
                </template>
                </tbody>
            </table>
        </div>
        </div>
</div>


<cfoutput>
    #view('/common/fragment/dealdetails')# 
</cfoutput>
