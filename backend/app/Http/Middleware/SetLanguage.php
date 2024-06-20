<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class SetLanguage
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        $acceptLangHeader = trim($request->header('ACCEPT-LANGUAGE'));
        $acceptedLanguages = explode(',', $acceptLangHeader); // 'fr-CH, fr;q=0.9, en;q=0.8, de;q=0.7, *;q=0.5' or 'en'
        $firstLanguage = isset($acceptedLanguages[0]) ? $acceptedLanguages[0] : null; // 'en-US;q=0.5' or 'en'
        $acceptedLanguage2LetterCode = $firstLanguage ? substr($firstLanguage, 0, 2) : null; // en

        $supportedLangs = ['en', 'pt'];
        
        if ($acceptedLanguage2LetterCode && in_array($acceptedLanguage2LetterCode, $supportedLangs)) {
            app()->setLocale($acceptedLanguage2LetterCode);
        }   
        
        return $next($request);
    }
}
