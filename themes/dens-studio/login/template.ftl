<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayRequiredFields=false section="">
<!DOCTYPE html>
<html class="${properties.kcHtmlClass!}" lang="<#if locale?? && locale.currentLanguageTag??>${locale.currentLanguageTag}<#else>it</#if>">
<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="robots" content="noindex, nofollow">
    <meta name="viewport" content="width=device-width,initial-scale=1">

    <#if properties.meta?has_content>
        <#list properties.meta?split(' ') as meta>
            <meta name="${meta?split('==')[0]}" content="${meta?split('==')[1]}"/>
        </#list>
    </#if>

    <title><#attempt><#nested "header"><#recover>${msg("loginTitle")}</#attempt></title>

    <#if properties.stylesCommon?has_content>
        <#list properties.stylesCommon?split(' ') as style>
            <link href="${url.resourcesCommonPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>

    <#if properties.styles?has_content>
        <#list properties.styles?split(' ') as style>
            <link href="${url.resourcesPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>

    <#if properties.scripts?has_content>
        <#list properties.scripts?split(' ') as script>
            <script src="${url.resourcesPath}/${script}" defer></script>
        </#list>
    </#if>

    <#if scripts??>
        <#list scripts as script>
            <script src="${script}" defer></script>
        </#list>
    </#if>
</head>
<body class="dens-login-body ${bodyClass!}">
    <div class="dens-shell">
        <div class="dens-stack">
            <div class="dens-brand" aria-label="${msg('brandTitle')}">
                <img
                    class="dens-brand__icon"
                    src="${url.resourcesPath}/${properties.densBrandIcon!'img/icon-brand.svg'}"
                    alt="${msg('brandTitle')}"
                />
                <div class="dens-brand__copy">
                    <div class="dens-brand__title">${msg("brandTitle")}</div>
                    <div class="dens-brand__subtitle">${msg("brandSubtitle")}</div>
                </div>
            </div>

            <#if properties.densBackToSelectionUrl?? && properties.densBackToSelectionUrl?has_content>
                <a class="dens-back" href="${properties.densBackToSelectionUrl}">
                    <span class="dens-back__arrow" aria-hidden="true">←</span>
                    <span>${msg("backToSelection")}</span>
                </a>
            </#if>

            <main class="dens-card" role="main">
                <header class="dens-card__header">
                    <h1 class="dens-card__title"><#nested "header"></h1>
                    <p class="dens-card__subtitle"><#attempt><#nested "subtitle"><#recover>${msg("loginSubtitle")}</#attempt></p>
                    <#if displayRequiredFields>
                        <p class="dens-required-note">* ${msg("requiredFields")}</p>
                    </#if>
                </header>

                <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
                    <div class="dens-alert dens-alert--${message.type!'info'}" role="alert">
                        ${kcSanitize(message.summary)?no_esc}
                    </div>
                </#if>

                <section class="dens-card__body"><#nested "form"></section>

                <#attempt>
                    <#nested "socialProviders">
                <#recover>
                </#attempt>

                <#if displayInfo>
                    <section class="dens-card__info"><#nested "info"></section>
                </#if>
            </main>

            <footer class="dens-footer">${msg("loginFooter")}</footer>
        </div>
    </div>
</body>
</html>
</#macro>
