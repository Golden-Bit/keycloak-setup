<#import "template.ftl" as layout>

<@layout.registrationLayout displayMessage=false; section>
    <#if section = "header">
        ${messageHeader!msg("infoTitle")}
    <#elseif section = "subtitle">
        ${messageSummary!msg("infoSubtitle")}
    <#elseif section = "form">
        <div class="dens-info-block">
            <#if requiredActions??>
                <ul class="dens-info-list">
                    <#list requiredActions as reqActionItem>
                        <li>${kcSanitize(msg("requiredAction.${reqActionItem}"))?no_esc}</li>
                    </#list>
                </ul>
            </#if>

            <#if pageRedirectUri?has_content>
                <a class="dens-submit dens-submit--link" href="${pageRedirectUri}">${msg("backToApplication")}</a>
            <#elseif actionUri?has_content>
                <a class="dens-submit dens-submit--link" href="${actionUri}">${msg("proceedWithAction")}</a>
            <#elseif client.baseUrl?has_content>
                <a class="dens-submit dens-submit--link" href="${client.baseUrl}">${msg("backToApplication")}</a>
            </#if>
        </div>
    </#if>
</@layout.registrationLayout>
