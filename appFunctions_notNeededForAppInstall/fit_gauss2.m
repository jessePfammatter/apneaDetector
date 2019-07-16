function SSE  = fit_gauss2(guess, X, Y, displayflag)

[mu1 sig1 amp1 mu2 sig2 amp2] = deal(  guess(1), guess(2), guess(3), guess(4), guess(5), guess(6));

   
Est = amp1.*exp(-(X-mu1).^2./sig1.^2) + amp2.*exp(-(X-mu2).^2./sig2.^2);
    

SSE = sum( (Est-Y).^2 );


if displayflag
    bar(X, Y, 'k'); hold on
    plot(X, Est, 'r-'); hold off
    drawnow
end

