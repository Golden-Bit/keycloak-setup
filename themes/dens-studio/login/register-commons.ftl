<#macro termsAcceptance>
    <#if termsAcceptanceRequired??>
        <div class="dens-kc-field dens-kc-field--terms">
            <div class="dens-kc-input-wrap">
                <div class="dens-terms-card">
                    <div class="dens-terms-card__title">${msg("termsTitle")}</div>
                    <div id="kc-registration-terms-text" class="dens-terms-card__text">
                        ${kcSanitize(msg("termsText"))?no_esc}
                    </div>
                </div>
            </div>
        </div>

        <div class="dens-kc-field dens-kc-field--checkbox">
            <label class="dens-check dens-check--register" for="termsAccepted">
                <input
                    type="checkbox"
                    id="termsAccepted"
                    name="termsAccepted"
                    class="dens-check__input"
                    aria-invalid="<#if messagesPerField.existsError('termsAccepted')>true<#else>false</#if>"
                />
                <span class="dens-check__label">${msg("acceptTerms")}</span>
            </label>
            <#if messagesPerField.existsError('termsAccepted')>
                <span id="input-error-terms-accepted" class="dens-field-error" aria-live="polite">
                    ${kcSanitize(messagesPerField.get('termsAccepted'))?no_esc}
                </span>
            </#if>
        </div>
    </#if>
</#macro>
