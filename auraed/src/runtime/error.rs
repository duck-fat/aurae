use log::error;
use thiserror::Error;
use tonic::Status;

pub(crate) type Result<T> = std::result::Result<T, RuntimeError>;

#[derive(Error, Debug)]
pub(crate) enum RuntimeError {
    #[error("missing argument in request: {arg}")]
    MissingArgument { arg: String },

    #[error(transparent)]
    ValidationError(#[from] validation::ValidationError),

    #[error("internal error: {msg}: {err}")]
    Internal { msg: String, err: String },

    #[error("{resource} was not allocated")]
    Unallocated { resource: String },

    #[error(transparent)]
    CgroupsError(#[from] cgroups_rs::error::Error),

    #[error(transparent)]
    Other(#[from] anyhow::Error),
}

impl From<RuntimeError> for Status {
    fn from(err: RuntimeError) -> Self {
        let msg = err.to_string();
        error!("{msg}");
        match err {
            RuntimeError::MissingArgument { arg: _ }
            | RuntimeError::ValidationError { 0: _ } => {
                Self::failed_precondition(msg)
            }
            RuntimeError::Internal { msg: _, err: _ }
            | RuntimeError::CgroupsError { 0: _ }
            | RuntimeError::Other { 0: _ } => Self::internal(msg),
            RuntimeError::Unallocated { resource: _ } => Self::not_found(msg),
        }
    }
}
