import { Global, Module } from '@nestjs/common';
import { JobsZscoreService } from './services/jobs.zscore.service';
import { JobsZscoreController } from './controllers/jobs.zscore.controller';
import { QueueModule } from '../jobqueue/queue.module';
import { JobsZscoreNoAuthController } from './controllers/jobs.zscore.noauth.controller';

@Global()
@Module({
  imports: [QueueModule],
  controllers: [JobsZscoreController, JobsZscoreNoAuthController],
  providers: [JobsZscoreService],
  exports: [],
})
export class JobsModule {}
