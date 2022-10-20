function fRates = firingrate(SpikeTimes, TimeSamples, varargin)
%
% Calculate the firing rate at TimeSamples
%
% For a square window:
% firingrate(SpikeTimes, TimeSamples, windowWidth)
%
% Extra options:
% fRates = firingrate(SpikeTimes, TimeSamples, 'FilterType', 'exponential',...
%                    'TimeConstant', 0.05);
%
% For an exponential filter TimeConstant is the time at which 
% the firing rate decays to 1/e=0.3679 of its value.
%
% fRates = firingrate(SpikeTimes, TimeSamples, 'FilterType', 'boxcar',...
%                    'TimeConstant', 0.05);
%
% fRates = firingrate(SpikeTimes, TimeSamples, 'Attrit', [0 10]);
% 
% SpikeTimes can be either a vector of spiketimes or a cell array 
% containing a vector of spiketimes per cell.
% fRates:    spikes/second (one row per cell of "SpikeTimes").
%
% Options: 
% 'FilterType'   ,  'boxcar' or 'exponential'
% 'TimeConstant' ,  [.05] If 'Filtertype' is 'exponential' TimeConstant sets the
%                         decay rate of the exponential (see equation below).
%                         If 'Filtertype' is 'boxcar' TimeConstant sets
%                         the total length of the window.
% 'Attrit'       ,  [tIni tEnd] Either only one pair, or the number of rows
%                               must equal the number of spike vectors. 
%                               Attrit will put NANs at every TimeSample 
%                               falling outside the tIni tEnd bounds.
% 'Normalize'    ,  [TimeConstant Center] Always uses a boxcar filtertype.
%
% Examples:
% firingrate([1 2 3], 0:0.1:4 ,0.1);  % Square overlaping window
% firingrate([1 2 3], 0:0.1:4 ,0.1,'filtertype','exponential'); % Exp window
% firingrate({[1 2 3],[],[2 4 6]},1:1:7,.9)  % 3 trials, 2nd without spikes
%
%  vdl 2007-2021

% Check that at least 3 arguments are provided
if isempty(varargin)
    error('At least 3 inputs required: firingrate(spiketimes,timesamples,window)')
end

% For compatibility with previous versions 
if isscalar(varargin{1})
    % If the first element in varargin is a vector it is the TimeConstant
    TimeConstant = varargin{1};
    varargin{1}  = [];
else
    TimeConstant = getArgumentValue('TimeConstant' ,'errorIfEmpty', varargin{:});
end

FilterType   = getArgumentValue('FilterType'   ,'boxcar', varargin{:});

% Attrition times
attrit       = getArgumentValue('attrit',[TimeSamples(1) TimeSamples(end)],...
                              varargin{:},'warningoff'); 
% Normalization width and center
normWidthCenter= getArgumentValue('Normalize',[], varargin{:},'warningoff'); 

if ~iscell(SpikeTimes) % In case SpikeTimes is not a cell array
   SpikeTimes = {SpikeTimes};
end

% Error checking if attrition is needed
if size(attrit,1)>1 && size(attrit,1)~=length(SpikeTimes) 
   error('The number of rows in attrit must equal the number of SpikeTimes vectors.')
end

% Get the number of trials
ntrials = length(SpikeTimes);

% Initialize fRates matrix (a row for each trial)
fRates  = nan(ntrials,length(TimeSamples));   
TimeConstant = single(TimeConstant);

% Loop through each trial
for k = 1:ntrials
   spkT  = SpikeTimes{k};                   % Get the trial spikes.
   spkT  = single(spkT(:));                 % Make it a column vector

   if size(attrit,1)>1 % If only one pair or attrition times were provided
       % use that pair for all the trials.
      subtimesamp = (TimeSamples<= attrit(k,2) & TimeSamples>= attrit(k,1));
      
      subtimeSPK  = (spkT <= (attrit(k,2)+TimeConstant*5) & ...
                     spkT >= attrit(k,1)-TimeConstant*5);
   else % Otherwise use a different pair for each trial. 
      subtimesamp = (TimeSamples<= attrit(1,2) & TimeSamples>= attrit(1,1));
      subtimeSPK  = (spkT <= (attrit(1,2)+TimeConstant*5) & ...
                     spkT >= attrit(1,1)-TimeConstant*5);
   end
   timeSamples = single(TimeSamples(subtimesamp));
   spkT = spkT(subtimeSPK);
   
   % Attrit the spikes
   spkT  = single(spkT(:));

   spkT = repmat(spkT,1,size(timeSamples,2));
   timesamples = repmat(timeSamples,size(spkT,1),1);
   
   switch lower(FilterType)
      case 'boxcar' % Counts spikes between -TimeConstant/2 and
         % +TimeConstant2 of each time sample (i.e. it extends into the past and future) 
         fRate  = (sum(spkT>=(timesamples-TimeConstant/2) & ...
                       spkT< (timesamples+TimeConstant/2),1)/TimeConstant);
      case 'exponential' % Only counts spikes into the past. 
         SelectSpikesUpTo = TimeConstant * 7.5; % Time window within which
         % spike will contribute to the firing rate of each time sample.
         SpikesBeforeTimeSample=(spkT>(timesamples-SelectSpikesUpTo) & ...
                                 spkT<=(timesamples));
         DistanceToTimeSample = spkT - timesamples;
         DistanceToTimeSample = abs(SpikesBeforeTimeSample.*DistanceToTimeSample);
         fRate = 1./TimeConstant .* exp(-DistanceToTimeSample/TimeConstant);
         fRate(logical(SpikesBeforeTimeSample~=1))=0; % Remove those distances
         % that we are not considering.
         fRate = sum(fRate,1);
      otherwise
         error(['FilterType "' FilterType '" not supported'])
   end
   fRates(k,subtimesamp) = fRate;  % This is the quick solution to many trials
                                   % Look for better ones
end

% If normalization is required
if ~isempty(normWidthCenter)
  FRforNorm = firingrate(SpikeTimes, normWidthCenter(2), 'FilterType','boxcar', ...
                        'TimeConstant',normWidthCenter(1));
%  fRates = (fRates-(mean(FRforNorm)) ) / std(FRforNorm);
  fRates = fRates / mean(FRforNorm);  % Mikes normalization
end

if nargout==0 % Plot fRates if no output is required
   plotf(TimeSamples,fRates,'.-')
   xlabel('time (s)')
   ylabel('firing rate (spikes/s)')
end
