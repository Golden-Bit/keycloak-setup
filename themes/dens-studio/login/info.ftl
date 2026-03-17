<#import "template.ftl" as layout>

<@layout.registrationLayout displayMessage=false; section>
    <#if section = "header">
        ${msg("infoTitle")}
    <#elseif section = "subtitle">
        ${msg("infoSubtitle")}
    <#elseif section = "form">
        <div class="dens-info-message">
            <#if messageHeader??>
                <p class="dens-info-message__header">${kcSanitize(messageHeader)?no_esc}</p>
            </#if>
            <#if message.summary??>
                <div class="dens-info-message__body">${kcSanitize(message.summary)?no_esc}</div>
            </#if>
        </div>

        <div class="dens-register dens-register--back">
            <a class="dens-inline-link" href="${url.loginUrl}">${kcSanitize(msg("backToLogin"))?no_esc}</a>
        </div>
    </#if>
</@layout.registrationLayout>
