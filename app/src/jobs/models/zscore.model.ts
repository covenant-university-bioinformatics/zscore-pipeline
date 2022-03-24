import * as mongoose from 'mongoose';

//Interface that describe the properties that are required to create a new job
interface ZscoreAttrs {
  job: string;
  useTest: string;
  beta: string;
  se: string;
  pvalue: string;
}

// An interface that describes the extra properties that a eqtl model has
//collection level methods
interface ZscoreModel extends mongoose.Model<ZscoreDoc> {
  build(attrs: ZscoreAttrs): ZscoreDoc;
}

//An interface that describes a properties that a document has
export interface ZscoreDoc extends mongoose.Document {
  id: string;
  version: number;
  useTest: boolean;
  beta: number;
  se: number;
  pvalue: number;
}

const ZscoreSchema = new mongoose.Schema<ZscoreDoc, ZscoreModel>(
  {
    useTest: {
      type: Boolean,
      trim: true,
    },
    beta: {
      type: Number,
      trim: true,
    },
    se: {
      type: Number,
      trim: true,
      default: null,
    },
    pvalue: {
      type: Number,
      trim: true,
      default: null,
    },
    job: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'ZscoreJob',
      required: true,
    },
    version: {
      type: Number,
    },
  },
  {
    timestamps: true,
    versionKey: 'version',
    toJSON: {
      transform(doc, ret) {
        ret.id = ret._id;
        // delete ret._id;
        // delete ret.__v;
      },
    },
  },
);

//increments version when document updates
ZscoreSchema.set('versionKey', 'version');

//collection level methods
ZscoreSchema.statics.build = (attrs: ZscoreAttrs) => {
  return new ZscoreModel(attrs);
};

//create mongoose model
const ZscoreModel = mongoose.model<ZscoreDoc, ZscoreModel>(
  'Zscore',
  ZscoreSchema,
  'zscores',
);

export { ZscoreModel };
