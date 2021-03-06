//
//  MicrophoneController.m
//  MC
//
//  Created by Shengzhe Chen on 10/22/12.
//  Copyright (c) 2012 Shengzhe Chen. All rights reserved.
//

#import "MicrophoneController.h"

#define OUTPUTRATE      48000
#define SPECTRUMSIZE    8192
#define SPECTRUMRANGE   ((float)OUTPUTRATE / 2.0f)      /* 0 to nyquist */
#define BINSIZE         (SPECTRUMRANGE / (float)SPECTRUMSIZE)


static const float notefreq[120] =
{
    16.35f,   17.32f,   18.35f,   19.45f,    20.60f,    21.83f,    23.12f,    24.50f,    25.96f,    27.50f,    29.14f,    30.87f,
    32.70f,   34.65f,   36.71f,   38.89f,    41.20f,    43.65f,    46.25f,    49.00f,    51.91f,    55.00f,    58.27f,    61.74f,
    65.41f,   69.30f,   73.42f,   77.78f,    82.41f,    87.31f,    92.50f,    98.00f,   103.83f,   110.00f,   116.54f,   123.47f,
    130.81f,  138.59f,  146.83f,  155.56f,   164.81f,   174.61f,   185.00f,   196.00f,   207.65f,   220.00f,   233.08f,   246.94f,
    261.63f,  277.18f,  293.66f,  311.13f,   329.63f,   349.23f,   369.99f,   392.00f,   415.30f,   440.00f,   466.16f,   493.88f,
    523.25f,  554.37f,  587.33f,  622.25f,   659.26f,   698.46f,   739.99f,   783.99f,   830.61f,   880.00f,   932.33f,   987.77f,
    1046.50f, 1108.73f, 1174.66f, 1244.51f,  1318.51f,  1396.91f,  1479.98f,  1567.98f,  1661.22f,  1760.00f,  1864.66f,  1975.53f,
    2093.00f, 2217.46f, 2349.32f, 2489.02f,  2637.02f,  2793.83f,  2959.96f,  3135.96f,  3322.44f,  3520.00f,  3729.31f,  3951.07f,
    4186.01f, 4434.92f, 4698.64f, 4978.03f,  5274.04f,  5587.65f,  5919.91f,  6271.92f,  6644.87f,  7040.00f,  7458.62f,  7902.13f,
    8372.01f, 8869.84f, 9397.27f, 9956.06f, 10548.08f, 11175.30f, 11839.82f, 12543.85f, 13289.75f, 14080.00f, 14917.24f, 15804.26f
};

static MicrophoneController *sharedInstance;

void ERRCHECK(FMOD_RESULT result)
{
    if (result != FMOD_OK)
    {
        fprintf(stderr, "FMOD error! (%d) %s\n", result, FMOD_ErrorString(result));
        exit(-1);
    }
}

@implementation MicrophoneController
@synthesize lowPassResults;

+(MicrophoneController *)sharedInstance {
    if (sharedInstance == nil)
    {
        sharedInstance = [[MicrophoneController alloc] init];
    }
    return sharedInstance;
}

-(id) init {
    
    if (self = [super init]) {

        //[self initMic];
        system = nil;
        sound = nil;
        channel = nil;
        self.frequency = 0.0;
        isFmodEnable = NO;
    }
    return self;
}

-(void) initMic {
    
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat:44100.0], AVSampleRateKey,
                              [NSNumber numberWithInt:kAudioFormatAppleLossless], AVFormatIDKey,
                              [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                              [NSNumber numberWithInt:AVAudioQualityMedium], AVEncoderAudioQualityKey, nil];
    
    NSError *err;
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&err];
    isListening = NO;
    if (recorder) {
        
    }
    self.lowPassResults = 0.0f;
}

-(void) startFrenquency {
    
    if (isFmodEnable) {
        
        return;
    }
    
    FMOD_RESULT             result      = FMOD_OK;
    unsigned int            version     = 0;
    FMOD_CREATESOUNDEXINFO  exinfo      = {0};
    
    result = FMOD::System_Create(&system);
    ERRCHECK(result);
    
    result = system->getVersion(&version);
    ERRCHECK(result);
    
    if (version < FMOD_VERSION)
    {
        fprintf(stderr, "You are using an old version of FMOD %08x.  This program requires %08x\n", version, FMOD_VERSION);
        exit(-1);
    }
    
    result = system->setSoftwareFormat(OUTPUTRATE, FMOD_SOUND_FORMAT_PCM16, 1, 0, FMOD_DSP_RESAMPLER_LINEAR);
    ERRCHECK(result);
    
    result = system->init(32, FMOD_INIT_NORMAL | FMOD_INIT_ENABLE_PROFILE, NULL);
    ERRCHECK(result);
    
    memset(&exinfo, 0, sizeof(FMOD_CREATESOUNDEXINFO));
    
    exinfo.cbsize           = sizeof(FMOD_CREATESOUNDEXINFO);
    exinfo.numchannels      = 1;
    exinfo.format           = FMOD_SOUND_FORMAT_PCM16;
    exinfo.defaultfrequency = OUTPUTRATE;
    exinfo.length           = exinfo.defaultfrequency * sizeof(short) * exinfo.numchannels * 5;
    
    result = system->createSound(NULL, FMOD_2D | FMOD_SOFTWARE | FMOD_LOOP_NORMAL | FMOD_OPENUSER, &exinfo, &sound);
    ERRCHECK(result);
    
    result = system->recordStart(0, sound, true);
    ERRCHECK(result);
    
    usleep(20 * 1000);      /* Give it some time to record something */
    
    result = system->playSound(FMOD_CHANNEL_REUSE, sound, false, &channel);
    ERRCHECK(result);
    
    /* Dont hear what is being recorded otherwise it will feedback.  Spectrum analysis is done before volume scaling in the DSP chain */
    
    result = channel->setVolume(0);
    ERRCHECK(result);
    
    isFmodEnable = YES;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.002 target:self selector:@selector(timerUpdate:) userInfo:nil repeats:YES];
}

-(void) startDetecting {
    
    if (!isListening) {
        
        [self initMic];
        
        isListening = YES;
        [recorder prepareToRecord];
        recorder.meteringEnabled = YES;
        [recorder record];
        levelTimer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(levelTimerCallback:) userInfo:nil repeats:YES];
        self.lowPassResults = 0.0f;
    }
}

-(void) stopDetecting {
    
    if (isListening) {
        
        isListening = NO;
        [levelTimer invalidate];
        levelTimer = nil;
        [recorder stop];
        [recorder release];
        recorder = nil;
    }
}

-(void) levelTimerCallback:(NSTimer *)timer {
    
    [recorder updateMeters];
    
    const double ALPHA = 0.05;
    double averagePowerForChannel = pow(10, (0.01*[recorder averagePowerForChannel:0]));
    self.lowPassResults = ALPHA*averagePowerForChannel + (1.0-ALPHA)*self.lowPassResults;
}

-(void) timerUpdate:(NSTimer *)timer {
    
    FMOD_RESULT     result                  = FMOD_OK;
    static float    spectrum[SPECTRUMSIZE]  = {0};
    float           dominanthz              = 0.0f;
    float           max                     = 0.0f;
    int             dominantnote            = 0;
    int             bin                     = 0;
    
    result = channel->getSpectrum(spectrum, SPECTRUMSIZE, 0, FMOD_DSP_FFT_WINDOW_TRIANGLE);
    ERRCHECK(result);
    
    for (int i = 0; i < SPECTRUMSIZE; i++)
    {
        if (spectrum[i] > 0.01f && spectrum[i] > max)
        {
            max = spectrum[i];
            bin = i;
        }
    }
    
    dominanthz = (float)bin * BINSIZE;       /* dominant frequency min */
    
    for (int i = 0; i < 120; i++)
    {
        if (dominanthz >= notefreq[i] && dominanthz < notefreq[i + 1])
        {
            /* Which is it closer to, this note or the next note */
            if (fabs(dominanthz - notefreq[i]) < fabs(dominanthz - notefreq[i + 1]))
            {
                dominantnote = i;
            }
            else
            {
                dominantnote = i + 1;
            }
            
            break;
        }
    }
    
    if (system != NULL)
    {
        result = system->update();
        ERRCHECK(result);
    }
    
    self.frequency = dominanthz;
}

-(void) stopFrequency {
    
    if (!isFmodEnable) {
        
        return;
    }

    isFmodEnable = NO;

    [timer invalidate];
    
    if (sound) {
        
        sound->release();
        sound = NULL;
    }
    if (system) {
        
        system->release();
        system = NULL;
    }
    
}

-(void) dealloc {
    
    [self stopDetecting];
    [self stopFrequency];
    [levelTimer release];
    [recorder release];
    [super dealloc];
}

@end
